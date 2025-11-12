import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    // Load the language JSON file from the "lang" folder
    String jsonStringValues = await rootBundle.loadString(
      'lib/l10n/app_${locale.languageCode}${locale.countryCode != null ? '_${locale.countryCode}' : ''}.arb',
    );
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);

    _localizedStrings = mappedJson.map(
      (key, value) => MapEntry(key, value.toString()),
    );

    return true;
  }

  // 本地化字符串
  String get appTitle => _localizedStrings['appTitle'] ?? 'UniSub';
  String get dragHint => _localizedStrings['dragHint'] ?? '拖拽视频或音频文件到这里';
  String get orText => _localizedStrings['orText'] ?? '或';
  String get selectFile => _localizedStrings['selectFile'] ?? '选择文件';
  String get pasteUrl => _localizedStrings['pasteUrl'] ?? '粘贴视频链接';
  String get processing => _localizedStrings['processing'] ?? '处理中...';
  String get downloadAudio => _localizedStrings['downloadAudio'] ?? '正在下载音频...';
  String get transcribing => _localizedStrings['transcribing'] ?? '正在转写...';
  String get translating => _localizedStrings['translating'] ?? '正在翻译...';
  String get speakerPrefix => _localizedStrings['speakerPrefix'] ?? '講者';
  String get exportSubtitle => _localizedStrings['exportSubtitle'] ?? '导出字幕';
  String get play => _localizedStrings['play'] ?? '播放';
  String get pause => _localizedStrings['pause'] ?? '暂停';
  String get settings => _localizedStrings['settings'] ?? '设置';
  String get language => _localizedStrings['language'] ?? '语言';
  String get model => _localizedStrings['model'] ?? '模型';
  String get subtitle => _localizedStrings['subtitle'] ?? '字幕';
  String get translation => _localizedStrings['translation'] ?? '翻译';
  String get network => _localizedStrings['network'] ?? '网络';
  String get cache => _localizedStrings['cache'] ?? '缓存';
  String get realtimeTranslation =>
      _localizedStrings['realtimeTranslation'] ?? '实时翻译';
  String get collapseTimeline =>
      _localizedStrings['collapseTimeline'] ?? '折叠时间轴';
  String get expandTimeline => _localizedStrings['expandTimeline'] ?? '展开时间轴';
  String get close => _localizedStrings['close'] ?? '关闭';
  String get theme => _localizedStrings['theme'] ?? '主题';
  String get themeDescription =>
      _localizedStrings['themeDescription'] ?? '设置应用主题样式';
  String get globalHotkey => _localizedStrings['globalHotkey'] ?? '全局热键';
  String get globalHotkeyDescription =>
      _localizedStrings['globalHotkeyDescription'] ?? '设置全局快捷键';
  String get languageSettingDescription =>
      _localizedStrings['languageSettingDescription'] ?? '设置应用显示语言';
  String get modelSettingDescription =>
      _localizedStrings['modelSettingDescription'] ?? '设置语音识别模型';
  String get subtitleSettingDescription =>
      _localizedStrings['subtitleSettingDescription'] ?? '设置字幕显示样式';
  String get translationSettingDescription =>
      _localizedStrings['translationSettingDescription'] ?? '设置翻译相关选项';
  String get networkSettingDescription =>
      _localizedStrings['networkSettingDescription'] ?? '设置网络连接选项';
  String get cacheSettingDescription =>
      _localizedStrings['cacheSettingDescription'] ?? '管理应用缓存文件';
  String get themeSettings => _localizedStrings['themeSettings'] ?? '主题设置';
  String get font => _localizedStrings['font'] ?? '字体';
  String get fontSize => _localizedStrings['fontSize'] ?? '字体大小';
  String get position => _localizedStrings['position'] ?? '位置';
  String get top => _localizedStrings['top'] ?? '顶部';
  String get bottom => _localizedStrings['bottom'] ?? '底部';
  String get clearCache => _localizedStrings['clearCache'] ?? '缓存已清理';
  String get notoSansTC => _localizedStrings['notoSansTC'] ?? '思源黑体';
  String get pingFang => _localizedStrings['pingFang'] ?? '苹方';

  // 主题设置相关
  String get systemTheme => _localizedStrings['systemTheme'] ?? '跟随系统';
  String get lightTheme => _localizedStrings['lightTheme'] ?? '浅色';
  String get darkTheme => _localizedStrings['darkTheme'] ?? '深色';

  // 翻译设置相关
  String get translationSettings =>
      _localizedStrings['translationSettings'] ?? '翻译设置';
  String get targetLanguage => _localizedStrings['targetLanguage'] ?? '目标语言';
  String get translationPostProcessing =>
      _localizedStrings['translationPostProcessing'] ?? '翻译后处理';

  // 网络设置相关
  String get networkSettings => _localizedStrings['networkSettings'] ?? '网络设置';
  String get onlineVideoSupport =>
      _localizedStrings['onlineVideoSupport'] ?? '启用在线视频支持';
  String get downloadSpeedLimit =>
      _localizedStrings['downloadSpeedLimit'] ?? '下载速度限制 (KB/s)';
  String get noLimit => _localizedStrings['noLimit'] ?? '无限制';
  String get proxyServer => _localizedStrings['proxyServer'] ?? '代理服务器';
  String get proxyServerHint =>
      _localizedStrings['proxyServerHint'] ??
      '例如: http://proxy.example.com:8080';

  // 缓存设置相关
  String get cacheSettings => _localizedStrings['cacheSettings'] ?? '缓存设置';
  String get autoCleanupPeriod =>
      _localizedStrings['autoCleanupPeriod'] ?? '自动清理周期';
  String get days => _localizedStrings['days'] ?? '天';
  String get cachePath => _localizedStrings['cachePath'] ?? '缓存路径';
  String get clearCacheButton =>
      _localizedStrings['clearCacheButton'] ?? '清理缓存';

  // 热键设置相关
  String get hotkeySettings => _localizedStrings['hotkeySettings'] ?? '全局热键';
  String get quickOpenApp => _localizedStrings['quickOpenApp'] ?? '快速打开应用';
  String get setHotkey => _localizedStrings['setHotkey'] ?? '设置';
  String get useDefault => _localizedStrings['useDefault'] ?? '使用默认';
  String get setGlobalHotkey =>
      _localizedStrings['setGlobalHotkey'] ?? '设置全局热键';
  String get pressDesiredHotkey =>
      _localizedStrings['pressDesiredHotkey'] ?? '请按下您想要设置的热键组合';
  String get cancel => _localizedStrings['cancel'] ?? '取消';

  // 状态栏相关
  String get ready => _localizedStrings['ready'] ?? '就绪';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return [
      'zh',
      'en',
      'ja',
      'ko',
      'fr',
      'es',
      'pt',
      'ar',
      'hi',
      'bn',
      'de',
      'ru',
    ].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
