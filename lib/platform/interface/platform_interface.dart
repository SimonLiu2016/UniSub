import 'dart:async';

/// Platform interface for video processing
abstract class PlatformVideoInterface {
  /// Download a video from URL
  Future<String> downloadVideo(
    String url,
    String platform,
    Function(double progress, String status) onProgress,
  );

  /// Get video information
  Future<Map<String, dynamic>> getVideoInfo(String url, String platform);

  /// Cancel current download
  Future<void> cancelDownload(String platform);
}
