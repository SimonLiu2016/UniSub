import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // 本地化字符串
  String get appTitle =>
      _localizedValues[locale.languageCode]?['appTitle'] ?? 'UniSub';
  String get dragHint =>
      _localizedValues[locale.languageCode]?['dragHint'] ?? '拖拽视频或音频文件到这里';
  String get orText => _localizedValues[locale.languageCode]?['orText'] ?? '或';
  String get selectFile =>
      _localizedValues[locale.languageCode]?['selectFile'] ?? '选择文件';
  String get pasteUrl =>
      _localizedValues[locale.languageCode]?['pasteUrl'] ?? '粘贴视频链接';
  String get processing =>
      _localizedValues[locale.languageCode]?['processing'] ?? '处理中...';
  String get downloadAudio =>
      _localizedValues[locale.languageCode]?['downloadAudio'] ?? '正在下载音频...';
  String get transcribing =>
      _localizedValues[locale.languageCode]?['transcribing'] ?? '正在转写...';
  String get translating =>
      _localizedValues[locale.languageCode]?['translating'] ?? '正在翻译...';
  String get speakerPrefix =>
      _localizedValues[locale.languageCode]?['speakerPrefix'] ?? '講者';
  String get exportSubtitle =>
      _localizedValues[locale.languageCode]?['exportSubtitle'] ?? '导出字幕';
  String get play => _localizedValues[locale.languageCode]?['play'] ?? '播放';
  String get pause => _localizedValues[locale.languageCode]?['pause'] ?? '暂停';
  String get settings =>
      _localizedValues[locale.languageCode]?['settings'] ?? '设置';
  String get language =>
      _localizedValues[locale.languageCode]?['language'] ?? '语言';
  String get model => _localizedValues[locale.languageCode]?['model'] ?? '模型';
  String get subtitle =>
      _localizedValues[locale.languageCode]?['subtitle'] ?? '字幕';
  String get translation =>
      _localizedValues[locale.languageCode]?['translation'] ?? '翻译';
  String get network =>
      _localizedValues[locale.languageCode]?['network'] ?? '网络';
  String get cache => _localizedValues[locale.languageCode]?['cache'] ?? '缓存';
  String get realtimeTranslation =>
      _localizedValues[locale.languageCode]?['realtimeTranslation'] ?? '实时翻译';
  String get collapseTimeline =>
      _localizedValues[locale.languageCode]?['collapseTimeline'] ?? '折叠时间轴';
  String get expandTimeline =>
      _localizedValues[locale.languageCode]?['expandTimeline'] ?? '展开时间轴';
  String get close => _localizedValues[locale.languageCode]?['close'] ?? '关闭';

  // 本地化值映射
  static final Map<String, Map<String, String>> _localizedValues = {
    'zh': {
      'appTitle': 'UniSub',
      'dragHint': '拖拽视频或音频文件到这里',
      'orText': '或',
      'selectFile': '选择文件',
      'pasteUrl': '粘贴视频链接',
      'processing': '处理中...',
      'downloadAudio': '正在下载音频...',
      'transcribing': '正在转写...',
      'translating': '正在翻译...',
      'speakerPrefix': '講者',
      'exportSubtitle': '导出字幕',
      'play': '播放',
      'pause': '暂停',
      'settings': '设置',
      'language': '语言',
      'model': '模型',
      'subtitle': '字幕',
      'translation': '翻译',
      'network': '网络',
      'cache': '缓存',
      'realtimeTranslation': '实时翻译',
      'collapseTimeline': '折叠时间轴',
      'expandTimeline': '展开时间轴',
      'close': '关闭',
    },
    'en': {
      'appTitle': 'UniSub',
      'dragHint': 'Drag video or audio files here',
      'orText': 'or',
      'selectFile': 'Select File',
      'pasteUrl': 'Paste video URL',
      'processing': 'Processing...',
      'downloadAudio': 'Downloading audio...',
      'transcribing': 'Transcribing...',
      'translating': 'Translating...',
      'speakerPrefix': 'Speaker',
      'exportSubtitle': 'Export Subtitle',
      'play': 'Play',
      'pause': 'Pause',
      'settings': 'Settings',
      'language': 'Language',
      'model': 'Model',
      'subtitle': 'Subtitle',
      'translation': 'Translation',
      'network': 'Network',
      'cache': 'Cache',
      'realtimeTranslation': 'Real-time Translation',
      'collapseTimeline': 'Collapse Timeline',
      'expandTimeline': 'Expand Timeline',
      'close': 'Close',
    },
    'ja': {
      'appTitle': 'UniSub',
      'dragHint': 'ここに動画または音声ファイルをドラッグ',
      'orText': 'または',
      'selectFile': 'ファイルを選択',
      'pasteUrl': '動画URLを貼り付け',
      'processing': '処理中...',
      'downloadAudio': '音声をダウンロード中...',
      'transcribing': '文字起こし中...',
      'translating': '翻訳中...',
      'speakerPrefix': '話者',
      'exportSubtitle': '字幕をエクスポート',
      'play': '再生',
      'pause': '一時停止',
      'settings': '設定',
      'language': '言語',
      'model': 'モデル',
      'subtitle': '字幕',
      'translation': '翻訳',
      'network': 'ネットワーク',
      'cache': 'キャッシュ',
      'realtimeTranslation': 'リアルタイム翻訳',
      'collapseTimeline': 'タイムラインを折りたたむ',
      'expandTimeline': 'タイムラインを展開',
      'close': '閉じる',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['zh', 'en', 'ja'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
