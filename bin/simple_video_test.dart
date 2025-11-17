import 'dart:io';
import 'dart:convert';

void main() async {
  // 简单测试HTTP请求
  try {
    final url = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';
    print('Testing URL: $url');

    // 创建HTTP客户端并设置超时
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 10);

    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();

    print('Status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      // 读取响应内容（限制读取大小以避免内存问题）
      final content = await response.transform(utf8.decoder).take(10000).join();
      print('Content length: ${content.length}');

      // 简单检查是否包含视频相关关键词
      final lowerContent = content.toLowerCase();
      final hasVideoTags = lowerContent.contains('<video');
      final hasYoutubeEmbed = lowerContent.contains('youtube.com/embed');
      final hasPlayer = lowerContent.contains('player');

      print('Has <video> tags: $hasVideoTags');
      print('Has YouTube embed: $hasYoutubeEmbed');
      print('Has player keyword: $hasPlayer');

      if (hasVideoTags || hasYoutubeEmbed || hasPlayer) {
        print('页面可能包含视频内容');
      } else {
        print('页面可能不包含视频内容');
      }
    } else {
      print('Failed to fetch page');
    }

    // 关闭客户端
    client.close();
  } catch (e) {
    print('Error: $e');
  }
}
