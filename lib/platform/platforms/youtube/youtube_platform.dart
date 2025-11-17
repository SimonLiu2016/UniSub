import '../../base/video_platform_base.dart';

class YouTubePlatform extends VideoPlatformBase {
  @override
  String get platformName => 'youtube';

  @override
  bool isValidUrl(String url) {
    final youtubeRegex = RegExp(
      r'^(https?:\/\/)?(www\.)?(youtube\.com|youtu\.?be)\/.+',
      caseSensitive: false,
    );
    return youtubeRegex.hasMatch(url);
  }

  @override
  Future<String> downloadVideo(
    String url,
    Function(double progress, String status) onProgress,
  ) async {
    // Implementation would use the macOS platform interface
    throw UnimplementedError('YouTube download not implemented');
  }

  @override
  Future<Map<String, dynamic>> getVideoInfo(String url) async {
    // Implementation would use the macOS platform interface
    throw UnimplementedError('YouTube video info not implemented');
  }

  @override
  Future<void> cancelDownload() async {
    // Implementation would use the macOS platform interface
    throw UnimplementedError('YouTube cancel download not implemented');
  }
}
