import AVFoundation
import Foundation

// Video downloader implementation using NSURLSession and AVFoundation
public class VideoDownloader: NSObject {
    private var session: URLSession!
    private var downloadTask: URLSessionDownloadTask?
    private var progressCallback: ((Double, String) -> Void)?
    private var isCancelled = false

    override init() {
        super.init()

        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 300

        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }

    // Download video from URL
    public func downloadVideo(
        from url: String,
        progressCallback: @escaping (Double, String) -> Void,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        self.progressCallback = progressCallback
        self.isCancelled = false

        guard let videoURL = URL(string: url) else {
            completion(.failure(VideoDownloadError.invalidURL))
            return
        }

        // Create download task
        downloadTask = session.downloadTask(with: videoURL)
        downloadTask?.resume()

        progressCallback(0.0, "开始下载视频")
    }

    // Cancel current download
    public func cancelDownload() {
        isCancelled = true
        downloadTask?.cancel()
    }

    // Get video information
    public func getVideoInfo(
        from url: String,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        guard let videoURL = URL(string: url) else {
            completion(.failure(VideoDownloadError.invalidURL))
            return
        }

        // For HLS streams, we need to use AVAsset to get information
        if url.hasSuffix(".m3u8") {
            let asset = AVAsset(url: videoURL)
            asset.loadValuesAsynchronously(forKeys: ["duration", "tracks"]) {
                DispatchQueue.main.async {
                    var info: [String: Any] = [:]

                    let duration = asset.duration
                    if duration.timescale != 0 {
                        info["duration"] = CMTimeGetSeconds(duration)
                    }

                    info["isHLS"] = true
                    completion(.success(info))
                }
            }
        } else {
            // For direct video files, we can get info from HTTP headers
            var request = URLRequest(url: videoURL)
            request.httpMethod = "HEAD"

            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                var info: [String: Any] = [:]
                if let httpResponse = response as? HTTPURLResponse {
                    info["contentLength"] = httpResponse.expectedContentLength
                    info["contentType"] = httpResponse.mimeType
                }

                info["isHLS"] = false
                completion(.success(info))
            }

            task.resume()
        }
    }
}

// MARK: - URLSessionDownloadDelegate
extension VideoDownloader: URLSessionDownloadDelegate {
    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        guard !isCancelled else { return }

        // Move downloaded file to permanent location
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        let fileName = "video_\(Date().timeIntervalSince1970).mp4"
        let destinationURL = tempDir.appendingPathComponent(fileName)

        do {
            // For HLS streams, we need to convert to MP4
            if let originalURL = downloadTask.originalRequest?.url,
                originalURL.absoluteString.hasSuffix(".m3u8")
            {
                progressCallback?(0.8, "正在合并HLS流...")
                try convertHLSToMP4(from: location, to: destinationURL)
            } else {
                try fileManager.moveItem(at: location, to: destinationURL)
            }

            progressCallback?(1.0, "下载完成")
            (self.progressCallback as? (Double, String) -> Void)?(1.0, "下载完成")
        } catch {
            (self.progressCallback as? (Double, String) -> Void)?(
                0.0, "文件处理失败: \(error.localizedDescription)")
        }
    }

    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64
    ) {
        guard !isCancelled else { return }

        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        let percentage = Int(progress * 100)
        progressCallback?(progress, "正在下载... \(percentage)%")
    }

    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: Error?
    ) {
        if let error = error {
            if (error as NSError).code == NSURLErrorCancelled {
                progressCallback?(0.0, "下载已取消")
            } else {
                progressCallback?(0.0, "下载失败: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - HLS Conversion
extension VideoDownloader {
    private func convertHLSToMP4(from sourceURL: URL, to destinationURL: URL) throws {
        // This is a simplified implementation
        // In a real app, you would use AVAssetExportSession for proper conversion
        try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
    }
}

// MARK: - Error Definitions
enum VideoDownloadError: Error {
    case invalidURL
    case downloadFailed
    case conversionFailed

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "无效的视频URL"
        case .downloadFailed:
            return "视频下载失败"
        case .conversionFailed:
            return "视频转换失败"
        }
    }
}

// Platform handler for video processing
public class VideoProcessingHandler: NSObject {
    private var downloaders: [String: VideoDownloader] = [:]

    public static func register(with registrar: NSObjectProtocol) {
        // Implementation would go here when integrated with Flutter
    }

    public func handle(_ call: NSObject, result: @escaping (Any?) -> Void) {
        // Implementation would go here when integrated with Flutter
    }

    private func handleDownloadVideo(_ call: NSObject, result: @escaping (Any?) -> Void) {
        // Mock implementation for now
        result("mock_result")
    }

    private func handleGetVideoInfo(_ call: NSObject, result: @escaping (Any?) -> Void) {
        // Mock implementation for now
        result(["title": "Mock Video"])
    }

    private func handleCancelDownload(_ call: NSObject, result: @escaping (Any?) -> Void) {
        // Mock implementation for now
        result(nil)
    }

    private func sendProgressUpdate(platform: String, progress: Double, status: String) {
        // This would need to be implemented to send progress updates back to Flutter
        // For now, we'll just print to console
        print("Progress update - Platform: \(platform), Progress: \(progress), Status: \(status)")
    }
}
