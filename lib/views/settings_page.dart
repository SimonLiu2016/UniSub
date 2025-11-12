import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../constants/app_constants.dart';
import '../widgets/language_selector.dart';
import '../widgets/theme_switcher.dart';
import '../widgets/model_selector.dart';
import '../widgets/translation_settings.dart';
import '../widgets/network_settings.dart';
import '../widgets/cache_settings.dart';
import '../widgets/hotkey_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // 设置值
  String _language = AppConstants.defaultLanguage;
  String _theme = AppConstants.defaultTheme;
  String _model = AppConstants.defaultModel;
  String _subtitleFont = AppConstants.defaultSubtitleFont;
  double _subtitleFontSize = AppConstants.defaultSubtitleFontSize;
  String _subtitleColor = AppConstants.defaultSubtitleColor;
  String _subtitlePosition = AppConstants.defaultSubtitlePosition;
  String _translateTarget = AppConstants.defaultTranslateTarget;
  bool _realtimeTranslation = AppConstants.defaultRealtimeTranslation;
  bool _translationPostProcessing =
      AppConstants.defaultTranslationPostProcessing;
  bool _onlineVideoSupport = AppConstants.defaultOnlineVideoSupport;
  int _downloadSpeedLimit = AppConstants.defaultDownloadSpeedLimit;
  int _cacheCleanupPeriod = AppConstants.defaultCacheCleanupPeriod;
  String _globalHotkey = 'Cmd+Shift+S';
  String _proxyServer = '';
  String _cachePath = '~/Library/Caches/UniSub';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.settings)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 语言设置
              _buildSection(
                context,
                localizations.language,
                LanguageSelector(
                  selectedLanguage: _language,
                  onLanguageChanged: (value) =>
                      setState(() => _language = value),
                  languages: AppConstants.supportedLanguages,
                ),
              ),

              const SizedBox(height: 16),

              // 主题设置
              _buildSection(
                context,
                '主题',
                ThemeSwitcher(
                  selectedTheme: _theme,
                  onThemeChanged: (value) => setState(() => _theme = value),
                ),
              ),

              const SizedBox(height: 16),

              // 模型设置
              _buildSection(
                context,
                localizations.model,
                ModelSelector(
                  selectedModel: _model,
                  onModelChanged: (value) => setState(() => _model = value),
                  models: AppConstants.whisperModels,
                ),
              ),

              const SizedBox(height: 16),

              // 字幕设置
              _buildSection(
                context,
                localizations.subtitle,
                _buildSubtitleSettings(),
              ),

              const SizedBox(height: 16),

              // 翻译设置
              _buildSection(
                context,
                localizations.translation,
                TranslationSettings(
                  targetLanguage: _translateTarget,
                  realtimeTranslation: _realtimeTranslation,
                  postProcessing: _translationPostProcessing,
                  onSettingsChanged: (targetLang, realtime, postProcess) {
                    setState(() {
                      _translateTarget = targetLang;
                      _realtimeTranslation = realtime;
                      _translationPostProcessing = postProcess;
                    });
                  },
                  languages: AppConstants.supportedLanguages,
                ),
              ),

              const SizedBox(height: 16),

              // 网络设置
              _buildSection(
                context,
                localizations.network,
                NetworkSettings(
                  onlineVideoSupport: _onlineVideoSupport,
                  downloadSpeedLimit: _downloadSpeedLimit,
                  proxyServer: _proxyServer,
                  onSettingsChanged: (onlineSupport, speedLimit, proxy) {
                    setState(() {
                      _onlineVideoSupport = onlineSupport;
                      _downloadSpeedLimit = speedLimit;
                      _proxyServer = proxy;
                    });
                  },
                ),
              ),

              const SizedBox(height: 16),

              // 缓存设置
              _buildSection(
                context,
                localizations.cache,
                CacheSettings(
                  cacheCleanupPeriod: _cacheCleanupPeriod,
                  cachePath: _cachePath,
                  onCleanupPeriodChanged: (value) =>
                      setState(() => _cacheCleanupPeriod = value),
                  onClearCache: _clearCache,
                ),
              ),

              const SizedBox(height: 16),

              // 热键设置
              _buildSection(
                context,
                '全局热键',
                HotkeySettings(
                  globalHotkey: _globalHotkey,
                  onHotkeyChanged: (value) =>
                      setState(() => _globalHotkey = value),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildSubtitleSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 字体设置
            const Text('字体'),
            DropdownButton<String>(
              value: _subtitleFont,
              items: const [
                DropdownMenuItem(value: 'NotoSansTC', child: Text('思源黑体')),
                DropdownMenuItem(value: 'PingFang', child: Text('苹方')),
                DropdownMenuItem(value: 'Arial', child: Text('Arial')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _subtitleFont = value);
                }
              },
            ),

            const SizedBox(height: 16),

            // 字体大小
            const Text('字体大小'),
            Slider(
              value: _subtitleFontSize,
              min: 12,
              max: 36,
              divisions: 24,
              label: _subtitleFontSize.round().toString(),
              onChanged: (value) {
                setState(() => _subtitleFontSize = value);
              },
            ),

            const SizedBox(height: 16),

            // 字幕位置
            const Text('位置'),
            DropdownButton<String>(
              value: _subtitlePosition,
              items: const [
                DropdownMenuItem(value: 'top', child: Text('顶部')),
                DropdownMenuItem(value: 'bottom', child: Text('底部')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _subtitlePosition = value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _clearCache() {
    // 清理缓存的实现
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('缓存已清理')));
  }
}
