import 'dart:async';
import 'package:flutter/services.dart';
import '../interface/platform_interface.dart';

/// macOS implementation of platform video interface
class MacOSPlatformVideo implements PlatformVideoInterface {
  static const MethodChannel _channel = MethodChannel(
    'unisub/video_processing',
  );

  @override
  Future<String> downloadVideo(
    String url,
    String platform,
    Function(double progress, String status) onProgress,
  ) async {
    try {
      // Set up progress callback
      _channel.setMethodCallHandler((call) async {
        if (call.method == 'onDownloadProgress') {
          final args = call.arguments as Map;
          final progress = args['progress'] as double;
          final status = args['status'] as String;
          onProgress(progress, status);
        }
      });

      // Call native method
      final result = await _channel.invokeMethod('downloadVideo', {
        'url': url,
        'platform': platform,
      });

      return result as String;
    } on PlatformException catch (e) {
      throw Exception('Download failed: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> getVideoInfo(String url, String platform) async {
    try {
      final result = await _channel.invokeMethod('getVideoInfo', {
        'url': url,
        'platform': platform,
      });

      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      throw Exception('Get video info failed: ${e.message}');
    }
  }

  @override
  Future<void> cancelDownload(String platform) async {
    try {
      await _channel.invokeMethod('cancelDownload', {'platform': platform});
    } on PlatformException catch (e) {
      throw Exception('Cancel download failed: ${e.message}');
    }
  }
}
