class AppConstants {
  // 应用信息
  static const String appName = 'UniSub';
  static const String appVersion = '1.2.0';

  // 支持的平台
  static const List<String> supportedPlatforms = [
    'youtube',
    'bilibili',
    'x', // Twitter
    'tiktok',
    'instagram',
    'facebook',
  ];

  // 支持的字幕格式
  static const List<String> subtitleFormats = ['srt', 'vtt', 'ass'];

  // Whisper模型选项
  static const List<Map<String, dynamic>> whisperModels = [
    {'name': 'base', 'displayName': 'Base (75MB)', 'size': 75},
    {'name': 'small', 'displayName': 'Small (243MB)', 'size': 243},
    {'name': 'medium', 'displayName': 'Medium (750MB)', 'size': 750},
    {'name': 'large-v3', 'displayName': 'Large-v3 (1.5GB)', 'size': 1500},
  ];

  // 支持的语言
  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'zh_TW', 'name': '繁體中文'},
    {'code': 'zh_CN', 'name': '简体中文'},
    {'code': 'en', 'name': 'English'},
    {'code': 'ja', 'name': '日本語'},
    {'code': 'ko', 'name': '한국어'},
  ];

  // 默认设置
  static const String defaultLanguage = 'zh_TW';
  static const String defaultTheme = 'system';
  static const String defaultModel = 'medium';
  static const String defaultSubtitleFont = 'NotoSansTC';
  static const double defaultSubtitleFontSize = 16.0;
  static const String defaultSubtitleColor = '#FFFFFF';
  static const String defaultSubtitlePosition = 'bottom';
  static const String defaultTranslateTarget = 'zh_TW';
  static const bool defaultRealtimeTranslation = true;
  static const bool defaultTranslationPostProcessing = true;
  static const bool defaultOnlineVideoSupport = true;
  static const int defaultDownloadSpeedLimit = 0; // 0表示无限制
  static const int defaultCacheCleanupPeriod = 7; // 天
}
