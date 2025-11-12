import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

class TranslationSettings extends StatefulWidget {
  final String targetLanguage;
  final bool realtimeTranslation;
  final bool postProcessing;
  final Function(String, bool, bool) onSettingsChanged;
  final List<Map<String, String>> languages;

  const TranslationSettings({
    super.key,
    required this.targetLanguage,
    required this.realtimeTranslation,
    required this.postProcessing,
    required this.onSettingsChanged,
    required this.languages,
  });

  @override
  State<TranslationSettings> createState() => _TranslationSettingsState();
}

class _TranslationSettingsState extends State<TranslationSettings> {
  late String _targetLanguage;
  late bool _realtimeTranslation;
  late bool _postProcessing;

  @override
  void initState() {
    super.initState();
    _targetLanguage = widget.targetLanguage;
    _realtimeTranslation = widget.realtimeTranslation;
    _postProcessing = widget.postProcessing;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.translationSettings,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // 目标语言选择
            Text(localizations.targetLanguage),
            DropdownButton<String>(
              value: _targetLanguage,
              items: widget.languages.map((language) {
                return DropdownMenuItem<String>(
                  value: language['code']!,
                  child: Text(language['name']!),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _targetLanguage = value;
                  });
                  widget.onSettingsChanged(
                    _targetLanguage,
                    _realtimeTranslation,
                    _postProcessing,
                  );
                }
              },
            ),

            const SizedBox(height: 16),

            // 实时翻译开关
            SwitchListTile(
              title: Text(localizations.realtimeTranslation),
              value: _realtimeTranslation,
              onChanged: (value) {
                setState(() {
                  _realtimeTranslation = value;
                });
                widget.onSettingsChanged(
                  _targetLanguage,
                  _realtimeTranslation,
                  _postProcessing,
                );
              },
            ),

            const SizedBox(height: 8),

            // 翻译后处理开关
            SwitchListTile(
              title: Text(localizations.translationPostProcessing),
              value: _postProcessing,
              onChanged: (value) {
                setState(() {
                  _postProcessing = value;
                });
                widget.onSettingsChanged(
                  _targetLanguage,
                  _realtimeTranslation,
                  _postProcessing,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
