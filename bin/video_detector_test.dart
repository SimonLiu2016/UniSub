import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

/// 独立的视频检测测试工具
/// 不依赖Flutter框架，可用于测试视频检测功能

class VideoDetector {
  /// 检测URL对应的页面是否有视频
  static Future<bool> hasVideo(String url) async {
    try {
      // 发送HTTP请求获取页面内容
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        print('无法获取页面内容，状态码: ${response.statusCode}');
        return false;
      }

      // 解析HTML内容
      final document = parse(response.body);

      // 检测页面中是否存在视频元素
      return _detectVideoElements(document);
    } catch (e) {
      print('检测视频时发生错误: $e');
      return false;
    }
  }

  /// 检测HTML文档中的视频元素
  static bool _detectVideoElements(document) {
    try {
      // 1. 检测<video>标签
      final videoTags = document.getElementsByTagName('video');
      if (videoTags.isNotEmpty) {
        print('检测到${videoTags.length}个<video>标签');
        return true;
      }

      // 2. 检测iframe标签（可能是嵌入的视频）
      final iframeTags = document.getElementsByTagName('iframe');
      for (var iframe in iframeTags) {
        final src = iframe.attributes['src'] ?? '';
        if (_isVideoIframe(src)) {
          print('检测到视频iframe: $src');
          return true;
        }
      }

      // 3. 检测包含视频相关关键词的元素
      final videoKeywords = [
        'youtube.com/embed/',
        'youtube.com/v/',
        'youtu.be/',
        'vimeo.com',
        'dailymotion.com',
        'tiktok.com',
        'instagram.com',
        'facebook.com',
        'twitter.com',
        'x.com',
        'bilibili.com',
        'player',
        'video',
      ];

      // 检查所有带有src属性的标签
      final elementsWithSrc = document.querySelectorAll('[src]');
      for (var element in elementsWithSrc) {
        final src = element.attributes['src'] ?? '';
        for (var keyword in videoKeywords) {
          if (src.toLowerCase().contains(keyword)) {
            print('检测到包含视频关键词的src: $src');
            return true;
          }
        }
      }

      // 检查所有带有data-src属性的标签
      final elementsWithDataSrc = document.querySelectorAll('[data-src]');
      for (var element in elementsWithDataSrc) {
        final src = element.attributes['data-src'] ?? '';
        for (var keyword in videoKeywords) {
          if (src.toLowerCase().contains(keyword)) {
            print('检测到包含视频关键词的data-src: $src');
            return true;
          }
        }
      }

      // 4. 检查页面标题或描述中是否包含视频相关关键词
      final title = document.querySelector('title')?.text ?? '';
      final metaDescription =
          document
              .querySelector('meta[name="description"]')
              ?.attributes['content'] ??
          '';
      final pageContent = '$title $metaDescription'.toLowerCase();

      final contentKeywords = [
        'video',
        'watch',
        'play',
        'stream',
        'movie',
        'clip',
      ];

      for (var keyword in contentKeywords) {
        if (pageContent.contains(keyword)) {
          print('检测到页面内容包含视频关键词: $keyword');
          return true;
        }
      }

      // 5. 检查特定平台的标识
      // 这里简化处理，直接通过URL判断
      final url =
          document.querySelector('link[rel="canonical"]')?.attributes['href'] ??
          '';
      if (_isSpecificVideoPlatform(url)) {
        return true;
      }

      print('未检测到视频元素');
      return false;
    } catch (e) {
      print('检测视频元素时发生错误: $e');
      return false;
    }
  }

  /// 判断iframe是否为视频iframe
  static bool _isVideoIframe(String src) {
    final videoDomains = [
      'youtube.com',
      'youtu.be',
      'vimeo.com',
      'dailymotion.com',
      'tiktok.com',
      'instagram.com',
      'facebook.com',
      'twitter.com',
      'x.com',
      'bilibili.com',
    ];

    for (var domain in videoDomains) {
      if (src.contains(domain)) {
        return true;
      }
    }

    return false;
  }

  /// 检测特定视频平台
  static bool _isSpecificVideoPlatform(String url) {
    try {
      // YouTube检测
      if (url.contains('youtube.com') || url.contains('youtu.be')) {
        // YouTube URL通常包含watch?v=或embed/
        return url.contains('watch?v=') || url.contains('embed/');
      }

      // Bilibili检测
      if (url.contains('bilibili.com')) {
        return url.contains('video/');
      }

      // Vimeo检测
      if (url.contains('vimeo.com')) {
        final pathSegments = Uri.parse(url).pathSegments;
        if (pathSegments.isNotEmpty) {
          // Vimeo视频URL通常是vimeo.com/数字ID
          return RegExp(r'^\d+$').hasMatch(pathSegments[0]);
        }
      }

      // TikTok检测
      if (url.contains('tiktok.com')) {
        return url.contains('/video/');
      }

      // Instagram检测
      if (url.contains('instagram.com')) {
        return url.contains('/p/') || url.contains('/reel/');
      }

      // Facebook检测
      if (url.contains('facebook.com') || url.contains('fb.com')) {
        return url.contains('/watch/') || url.contains('/video/');
      }

      // Twitter/X检测
      if (url.contains('twitter.com') || url.contains('x.com')) {
        return url.contains('/status/');
      }

      return false;
    } catch (e) {
      print('检测特定视频平台时发生错误: $e');
      return false;
    }
  }

  /// 获取页面中的视频信息
  static Future<Map<String, dynamic>> getVideoInfo(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        return {'hasVideo': false, 'error': '无法获取页面内容'};
      }

      final document = parse(response.body);
      final hasVideo = _detectVideoElements(document);

      return {
        'hasVideo': hasVideo,
        'url': url,
        'title': document.querySelector('title')?.text ?? '未知标题',
      };
    } catch (e) {
      return {'hasVideo': false, 'error': e.toString()};
    }
  }
}

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

  // 测试Bilibili URL
  final bilibiliUrl = 'https://www.bilibili.com/video/BV1GJ411x7h7';
  print('Testing Bilibili URL: $bilibiliUrl');

  final bilibiliResult = await VideoDetector.getVideoInfo(bilibiliUrl);
  print('Bilibili URL Result: $bilibiliResult');
}
