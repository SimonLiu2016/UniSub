/// Base class for video platform implementations
abstract class VideoPlatformBase {
  /// Check if the URL is valid for this platform
  bool isValidUrl(String url);

  /// Get platform name
  String get platformName;

  /// Download video from URL
  Future<String> downloadVideo(
    String url,
    Function(double progress, String status) onProgress,
  );

  /// Get video information
  Future<Map<String, dynamic>> getVideoInfo(String url);

  /// Cancel current download
  Future<void> cancelDownload();
}
