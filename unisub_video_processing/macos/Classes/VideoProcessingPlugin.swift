import Cocoa
import FlutterMacOS

public class VideoProcessingPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "unisub/video_processing",
            binaryMessenger: registrar.messenger
        )

        let instance = VideoProcessingPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getVideoInfo":
            handleGetVideoInfo(call, result: result)
        case "downloadVideo":
            handleDownloadVideo(call, result: result)
        case "cancelDownload":
            handleCancelDownload(call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func handleGetVideoInfo(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
            args["url"] as? String != nil
        else {
            result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
            return
        }

        // 这里应该调用实际的视频信息获取逻辑
        // 暂时返回模拟数据
        let videoInfo: [String: Any] = [
            "title": "示例视频标题",
            "duration": 300,
            "uploader": "示例上传者",
            "platform": "youtube",
        ]

        result(videoInfo)
    }

    private func handleDownloadVideo(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
            args["url"] as? String != nil,
            args["platform"] as? String != nil
        else {
            result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
            return
        }

        // 这里应该调用实际的视频下载逻辑
        // 暂时返回模拟数据
        result("/tmp/example_video.mp4")
    }

    private func handleCancelDownload(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        // 这里应该实现取消下载的逻辑
        result(nil)
    }
}
