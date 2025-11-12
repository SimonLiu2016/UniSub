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
  final Function(Locale)? onLocaleChanged;

  const SettingsPage({super.key, this.onLocaleChanged});

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 根据当前的locale更新_language变量
    _updateLanguageFromLocale();
  }

  void _updateLanguageFromLocale() {
    final locale = Localizations.localeOf(context);
    String languageCode = locale.languageCode;
    String countryCode = locale.countryCode ?? '';

    // 根据locale设置_language变量
    if (languageCode == 'zh') {
      if (countryCode == 'TW') {
        _language = 'zh_TW';
      } else {
        _language = 'zh_CN';
      }
    } else if (languageCode == 'ar') {
      // 阿拉伯语特殊处理
      _language = 'ar';
    } else if (languageCode == 'hi') {
      // 印地语特殊处理
      _language = 'hi';
    } else if (languageCode == 'bn') {
      // 孟加拉语特殊处理
      _language = 'bn';
    } else if (languageCode == 'de') {
      // 德语特殊处理
      _language = 'de';
    } else if (languageCode == 'ru') {
      // 俄语特殊处理
      _language = 'ru';
    } else {
      // 对于其他语言，直接使用languageCode
      _language = languageCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          // 自定义顶部工具栏 - 添加顶部安全边距以避免与系统控件重叠
          Container(
            padding: const EdgeInsets.only(top: 20), // 添加顶部边距
            child: _buildCustomAppBar(context, localizations.settings),
          ),

          // 设置菜单列表
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // 语言设置菜单项
                    _buildSettingsMenuItem(
                      context: context,
                      icon: Icons.language,
                      title: localizations.language,
                      description: localizations.languageSettingDescription,
                      onTap: () =>
                          _showLanguageSettingsDialog(context, localizations),
                    ),

                    const SizedBox(height: 12),

                    // 主题设置菜单项
                    _buildSettingsMenuItem(
                      context: context,
                      icon: Icons.brightness_6,
                      title: localizations.theme,
                      description: localizations.themeDescription,
                      onTap: () =>
                          _showThemeSettingsDialog(context, localizations),
                    ),

                    const SizedBox(height: 12),

                    // 模型设置菜单项
                    _buildSettingsMenuItem(
                      context: context,
                      icon: Icons.model_training,
                      title: localizations.model,
                      description: localizations.modelSettingDescription,
                      onTap: () =>
                          _showModelSettingsDialog(context, localizations),
                    ),

                    const SizedBox(height: 12),

                    // 字幕设置菜单项
                    _buildSettingsMenuItem(
                      context: context,
                      icon: Icons.subtitles,
                      title: localizations.subtitle,
                      description: localizations.subtitleSettingDescription,
                      onTap: () =>
                          _showSubtitleSettingsDialog(context, localizations),
                    ),

                    const SizedBox(height: 12),

                    // 翻译设置菜单项
                    _buildSettingsMenuItem(
                      context: context,
                      icon: Icons.translate,
                      title: localizations.translation,
                      description: localizations.translationSettingDescription,
                      onTap: () => _showTranslationSettingsDialog(
                        context,
                        localizations,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 网络设置菜单项
                    _buildSettingsMenuItem(
                      context: context,
                      icon: Icons.network_wifi,
                      title: localizations.network,
                      description: localizations.networkSettingDescription,
                      onTap: () =>
                          _showNetworkSettingsDialog(context, localizations),
                    ),

                    const SizedBox(height: 12),

                    // 缓存设置菜单项
                    _buildSettingsMenuItem(
                      context: context,
                      icon: Icons.storage,
                      title: localizations.cache,
                      description: localizations.cacheSettingDescription,
                      onTap: () =>
                          _showCacheSettingsDialog(context, localizations),
                    ),

                    const SizedBox(height: 12),

                    // 热键设置菜单项
                    _buildSettingsMenuItem(
                      context: context,
                      icon: Icons.keyboard,
                      title: localizations.globalHotkey,
                      description: localizations.globalHotkeyDescription,
                      onTap: () =>
                          _showHotkeySettingsDialog(context, localizations),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: theme.brightness == Brightness.dark
                ? Colors.grey.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // 返回按钮
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: theme.brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black54,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),

          // 标题
          Text(
            title,
            style: TextStyle(
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.brightness == Brightness.dark
          ? theme.colorScheme.surface
          : theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.brightness == Brightness.dark
              ? theme.colorScheme.outlineVariant
              : theme.colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.brightness == Brightness.dark
                ? Colors.white70
                : Colors.black54,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: theme.brightness == Brightness.dark
              ? Colors.white70
              : Colors.black54,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.brightness == Brightness.dark
                ? Colors.white70
                : Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark
                ? Colors.grey[800]
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(padding: const EdgeInsets.all(16.0), child: content),
        ),
      ],
    );
  }

  Widget _buildSubtitleSettings() {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 字体设置
        Text(localizations.font),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: _subtitleFont,
          items: [
            DropdownMenuItem(
              value: 'NotoSansTC',
              child: Text(localizations.notoSansTC),
            ),
            DropdownMenuItem(
              value: 'PingFang',
              child: Text(localizations.pingFang),
            ),
            const DropdownMenuItem(value: 'Arial', child: Text('Arial')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _subtitleFont = value);
            }
          },
          isExpanded: true,
        ),

        const SizedBox(height: 20),

        // 字体大小
        Text(localizations.fontSize),
        const SizedBox(height: 8),
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
        Text('${_subtitleFontSize.round()}pt', textAlign: TextAlign.end),

        const SizedBox(height: 20),

        // 字幕位置
        Text(localizations.position),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: _subtitlePosition,
          items: [
            DropdownMenuItem(value: 'top', child: Text(localizations.top)),
            DropdownMenuItem(
              value: 'bottom',
              child: Text(localizations.bottom),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _subtitlePosition = value);
            }
          },
          isExpanded: true,
        ),
      ],
    );
  }

  void _clearCache() {
    // 清理缓存的实现
    final localizations = AppLocalizations.of(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(localizations.clearCache)));
  }

  void _showLanguageSettingsDialog(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.language),
          content: SizedBox(
            width: 400,
            child: LanguageSelector(
              selectedLanguage: _language,
              onLanguageChanged: (value) {
                setState(() => _language = value);
                // 调用父组件的回调来更新语言
                if (widget.onLocaleChanged != null) {
                  // 根据语言代码创建对应的Locale对象
                  Locale locale;
                  switch (value) {
                    case 'zh_CN':
                      locale = const Locale('zh', 'CN');
                      break;
                    case 'zh_TW':
                      locale = const Locale('zh', 'TW');
                      break;
                    case 'en':
                      locale = const Locale('en');
                      break;
                    case 'ja':
                      locale = const Locale('ja');
                      break;
                    case 'ko':
                      locale = const Locale('ko');
                      break;
                    case 'fr':
                      locale = const Locale('fr');
                      break;
                    case 'es':
                      locale = const Locale('es');
                      break;
                    case 'pt':
                      locale = const Locale('pt');
                      break;
                    case 'ar':
                      locale = const Locale('ar');
                      break;
                    case 'hi':
                      locale = const Locale('hi');
                      break;
                    case 'bn':
                      locale = const Locale('bn');
                      break;
                    case 'de':
                      locale = const Locale('de');
                      break;
                    case 'ru':
                      locale = const Locale('ru');
                      break;
                    default:
                      locale = const Locale('en');
                  }
                  widget.onLocaleChanged!(locale);
                }
                Navigator.of(context).pop();
              },
              languages: AppConstants.supportedLanguages,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.close),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          backgroundColor: theme.brightness == Brightness.dark
              ? theme.colorScheme.surface
              : theme.colorScheme.surface,
        );
      },
    );
  }

  void _showThemeSettingsDialog(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.themeSettings),
          content: SizedBox(
            width: 400,
            child: ThemeSwitcher(
              selectedTheme: _theme,
              onThemeChanged: (value) {
                setState(() => _theme = value);
                Navigator.of(context).pop();
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.close),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          backgroundColor: theme.brightness == Brightness.dark
              ? theme.colorScheme.surface
              : theme.colorScheme.surface,
        );
      },
    );
  }

  void _showModelSettingsDialog(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.model),
          content: SizedBox(
            width: 400,
            child: ModelSelector(
              selectedModel: _model,
              onModelChanged: (value) {
                setState(() => _model = value);
                Navigator.of(context).pop();
              },
              models: AppConstants.whisperModels,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.close),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          backgroundColor: theme.brightness == Brightness.dark
              ? theme.colorScheme.surface
              : theme.colorScheme.surface,
        );
      },
    );
  }

  void _showSubtitleSettingsDialog(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.subtitle),
          content: SizedBox(width: 400, child: _buildSubtitleSettings()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.close),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          backgroundColor: theme.brightness == Brightness.dark
              ? theme.colorScheme.surface
              : theme.colorScheme.surface,
        );
      },
    );
  }

  void _showTranslationSettingsDialog(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.translation),
          content: SizedBox(
            width: 400,
            child: TranslationSettings(
              targetLanguage: _translateTarget,
              realtimeTranslation: _realtimeTranslation,
              postProcessing: _translationPostProcessing,
              onSettingsChanged: (targetLang, realtime, postProcess) {
                setState(() {
                  _translateTarget = targetLang;
                  _realtimeTranslation = realtime;
                  _translationPostProcessing = postProcess;
                });
                Navigator.of(context).pop();
              },
              languages: AppConstants.supportedLanguages,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.close),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          backgroundColor: theme.brightness == Brightness.dark
              ? theme.colorScheme.surface
              : theme.colorScheme.surface,
        );
      },
    );
  }

  void _showNetworkSettingsDialog(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.network),
          content: SizedBox(
            width: 400,
            child: NetworkSettings(
              onlineVideoSupport: _onlineVideoSupport,
              downloadSpeedLimit: _downloadSpeedLimit,
              proxyServer: _proxyServer,
              onSettingsChanged: (onlineSupport, speedLimit, proxy) {
                setState(() {
                  _onlineVideoSupport = onlineSupport;
                  _downloadSpeedLimit = speedLimit;
                  _proxyServer = proxy;
                });
                Navigator.of(context).pop();
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.close),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          backgroundColor: theme.brightness == Brightness.dark
              ? theme.colorScheme.surface
              : theme.colorScheme.surface,
        );
      },
    );
  }

  void _showCacheSettingsDialog(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.cache),
          content: SizedBox(
            width: 400,
            child: CacheSettings(
              cacheCleanupPeriod: _cacheCleanupPeriod,
              cachePath: _cachePath,
              onCleanupPeriodChanged: (value) {
                setState(() => _cacheCleanupPeriod = value);
              },
              onClearCache: _clearCache,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.close),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          backgroundColor: theme.brightness == Brightness.dark
              ? theme.colorScheme.surface
              : theme.colorScheme.surface,
        );
      },
    );
  }

  void _showHotkeySettingsDialog(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.globalHotkey),
          content: SizedBox(
            width: 400,
            child: HotkeySettings(
              globalHotkey: _globalHotkey,
              onHotkeyChanged: (value) {
                setState(() => _globalHotkey = value);
                Navigator.of(context).pop();
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.close),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          backgroundColor: theme.brightness == Brightness.dark
              ? theme.colorScheme.surface
              : theme.colorScheme.surface,
        );
      },
    );
  }
}
