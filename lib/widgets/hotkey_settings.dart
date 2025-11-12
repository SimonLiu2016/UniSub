import 'package:flutter/material.dart';

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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('全局热键', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),

            // 快速打开应用热键
            const Text('快速打开应用'),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(_globalHotkey),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _showHotkeyDialog,
                  child: const Text('设置'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _useDefaultHotkey,
                  child: const Text('使用默认'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showHotkeyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('设置全局热键'),
          content: const Text('请按下您想要设置的热键组合'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
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
