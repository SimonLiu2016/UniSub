import 'package:unisub/services/video_detector.dart';

void main() async {
  // 测试YouTube URL
  final youtubeUrl = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';
  print('Testing YouTube URL: $youtubeUrl');

  final youtubeResult = await VideoDetector.getVideoInfo(youtubeUrl);
  print('YouTube Result: $youtubeResult');

  // 测试普通网页URL
  final normalUrl = 'https://www.google.com';
  print('Testing normal URL: $normalUrl');

  final normalResult = await VideoDetector.getVideoInfo(normalUrl);
  print('Normal URL Result: $normalResult');
}
