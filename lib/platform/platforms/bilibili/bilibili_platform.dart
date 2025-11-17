import '../../base/video_platform_base.dart';

class BilibiliPlatform extends VideoPlatformBase {
  @override
  String get platformName => 'bilibili';

  @override
  bool isValidUrl(String url) {
    final bilibiliRegex = RegExp(
      r'^(https?:\/\/)?(www\.)?(bilibili\.com)\/.+',
      caseSensitive: false,
    );
    return bilibiliRegex.hasMatch(url);
  }

  @override
  Future<String> downloadVideo(
    String url,
    Function(double progress, String status) onProgress,
  ) async {
    // Implementation would use the macOS platform interface
    throw UnimplementedError('Bilibili download not implemented');
  }

  @override
  Future<Map<String, dynamic>> getVideoInfo(String url) async {
    // Implementation would use the macOS platform interface
    throw UnimplementedError('Bilibili video info not implemented');
  }

  @override
  Future<void> cancelDownload() async {
    // Implementation would use the macOS platform interface
    throw UnimplementedError('Bilibili cancel download not implemented');
  }
}
