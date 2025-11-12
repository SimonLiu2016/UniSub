import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

class HotkeySettings extends StatefulWidget {
  final String globalHotkey;
  final Function(String) onHotkeyChanged;

  const HotkeySettings({
    super.key,
    required this.globalHotkey,
    required this.onHotkeyChanged,
  });

  @override
  State<HotkeySettings> createState() => _HotkeySettingsState();
}

class _HotkeySettingsState extends State<HotkeySettings> {
  late String _globalHotkey;

  @override
  void initState() {
    super.initState();
    _globalHotkey = widget.globalHotkey;
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
              localizations.hotkeySettings,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // 快速打开应用热键
            Text(localizations.quickOpenApp),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(_globalHotkey),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _showHotkeyDialog,
                  child: Text(localizations.setHotkey),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _useDefaultHotkey,
                  child: Text(localizations.useDefault),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showHotkeyDialog() {
    final localizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.setGlobalHotkey),
          content: Text(localizations.pressDesiredHotkey),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(localizations.cancel),
            ),
          ],
        );
      },
    );
  }

  void _useDefaultHotkey() {
    setState(() {
      _globalHotkey = 'Cmd+Shift+S'; // macOS默认热键
    });
    widget.onHotkeyChanged(_globalHotkey);
  }
}
