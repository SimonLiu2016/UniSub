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

        // Check if this is a known video platform
        if isYouTubeURL(url) {
            downloadYouTubeVideo(
                from: url, progressCallback: progressCallback, completion: completion)
        } else if isBilibiliURL(url) {
            downloadBilibiliVideo(
                from: url, progressCallback: progressCallback, completion: completion)
        } else {
            guard let videoURL = URL(string: url) else {
                completion(.failure(VideoDownloadError.invalidURL))
                return
            }

            // Create download task
            downloadTask = session.downloadTask(with: videoURL)
            downloadTask?.resume()

            progressCallback(0.0, "开始下载视频")
        }
    }

    // Download YouTube video
    private func downloadYouTubeVideo(
        from url: String,
        progressCallback: @escaping (Double, String) -> Void,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        // For YouTube, we need to extract video ID and get actual video URL
        guard let videoID = extractYouTubeVideoID(from: url) else {
            completion(.failure(VideoDownloadError.invalidURL))
            return
        }

        // This is a simplified implementation
        // In a real implementation, you would need to:
        // 1. Fetch the YouTube page
        // 2. Parse the page to extract video information
        // 3. Extract available video formats and URLs
        // 4. Download the actual video content

        // For demonstration, we'll simulate the download process
        progressCallback(0.0, "正在解析YouTube视频...")

        // Simulate async work
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            DispatchQueue.main.async {
                progressCallback(0.3, "已获取视频信息")

                DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                    DispatchQueue.main.async {
                        // In a real implementation, you would download the actual video
                        // For now, we'll just return a mock file path
                        let fileManager = FileManager.default
                        let tempDir = fileManager.temporaryDirectory
                        let fileName = "youtube_\(videoID).mp4"
                        let destinationURL = tempDir.appendingPathComponent(fileName)

                        // Create a mock file
                        do {
                            try "YouTube video content".write(
                                to: destinationURL, atomically: true, encoding: .utf8)
                            progressCallback(1.0, "下载完成")
                            completion(.success(destinationURL.path))
                        } catch {
                            progressCallback(0.0, "下载失败: \(error.localizedDescription)")
                            completion(.failure(error))
                        }
                    }
                }
            }
        }
    }

    // Download Bilibili video
    private func downloadBilibiliVideo(
        from url: String,
        progressCallback: @escaping (Double, String) -> Void,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        // This is a simplified implementation
        // In a real implementation, you would need to parse the Bilibili page
        // and extract the actual video URL

        // For demonstration, we'll simulate the download process
        progressCallback(0.0, "正在解析Bilibili视频...")

        // Simulate async work
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            DispatchQueue.main.async {
                progressCallback(0.3, "已获取视频信息")

                DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                    DispatchQueue.main.async {
                        // In a real implementation, you would download the actual video
                        // For now, we'll just return a mock file path
                        let fileManager = FileManager.default
                        let tempDir = fileManager.temporaryDirectory
                        let fileName = "bilibili_video.mp4"
                        let destinationURL = tempDir.appendingPathComponent(fileName)

                        // Create a mock file
                        do {
                            try "Bilibili video content".write(
                                to: destinationURL, atomically: true, encoding: .utf8)
                            progressCallback(1.0, "下载完成")
                            completion(.success(destinationURL.path))
                        } catch {
                            progressCallback(0.0, "下载失败: \(error.localizedDescription)")
                            completion(.failure(error))
                        }
                    }
                }
            }
        }
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

        // Check if this is a known video platform
        if isYouTubeURL(url) {
            getYouTubeVideoInfo(from: url, completion: completion)
        } else if isBilibiliURL(url) {
            getBilibiliVideoInfo(from: url, completion: completion)
        } else if url.hasSuffix(".m3u8") {
            // For HLS streams, we need to use AVAsset to get information
            let asset = AVAsset(url: videoURL)
            asset.loadValuesAsynchronously(forKeys: ["duration", "tracks"]) {
                DispatchQueue.main.async {
                    var info: [String: Any] = [:]

                    let duration = asset.duration
                    if duration.timescale != 0 {
                        info["duration"] = CMTimeGetSeconds(duration)
                    }

                    info["isHLS"] = true
                    info["platform"] = "hls"
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
                info["platform"] = "direct"
                completion(.success(info))
            }

            task.resume()
        }
    }

    // Check if URL is a YouTube URL
    private func isYouTubeURL(_ url: String) -> Bool {
        return url.contains("youtube.com") || url.contains("youtu.be")
    }

    // Check if URL is a Bilibili URL
    private func isBilibiliURL(_ url: String) -> Bool {
        return url.contains("bilibili.com") || url.contains("b23.tv")
    }

    // Get YouTube video information
    private func getYouTubeVideoInfo(
        from url: String,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        // For YouTube, we need to extract video ID and get video info
        guard let videoID = extractYouTubeVideoID(from: url) else {
            completion(.failure(VideoDownloadError.invalidURL))
            return
        }

        // This is a simplified implementation
        // In a real implementation, you would need to:
        // 1. Fetch the YouTube page
        // 2. Parse the page to extract video information
        // 3. Extract available video formats and URLs

        var info: [String: Any] = [:]
        info["videoID"] = videoID
        info["platform"] = "youtube"
        info["title"] = "YouTube Video - \(videoID)"
        info["isHLS"] = false

        // For demonstration, we'll return mock data
        // In a real implementation, you would parse the actual YouTube page
        completion(.success(info))
    }

    // Get Bilibili video information
    private func getBilibiliVideoInfo(
        from url: String,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        // For Bilibili, we need to extract video ID and get video info
        // This is a simplified implementation

        var info: [String: Any] = [:]
        info["platform"] = "bilibili"
        info["title"] = "Bilibili Video"
        info["isHLS"] = false

        // For demonstration, we'll return mock data
        // In a real implementation, you would parse the actual Bilibili page
        completion(.success(info))
    }

    // Extract YouTube video ID from URL
    private func extractYouTubeVideoID(from url: String) -> String? {
        let patterns = [
            #"v=([\w_-]{11})"#,
            #"youtu\.be/([\w_-]{11})"#,
            #"embed/([\w_-]{11})"#,
        ]

        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern),
                let match = regex.firstMatch(in: url, range: NSRange(url.startIndex..., in: url)),
                let range = Range(match.range(at: 1), in: url)
            {
                return String(url[range])
            }
        }

        return nil
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
