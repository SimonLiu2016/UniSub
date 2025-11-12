import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

class CacheSettings extends StatefulWidget {
  final int cacheCleanupPeriod;
  final String cachePath;
  final Function(int) onCleanupPeriodChanged;
  final Function() onClearCache;

  const CacheSettings({
    super.key,
    required this.cacheCleanupPeriod,
    required this.cachePath,
    required this.onCleanupPeriodChanged,
    required this.onClearCache,
  });

  @override
  State<CacheSettings> createState() => _CacheSettingsState();
}

class _CacheSettingsState extends State<CacheSettings> {
  late int _cacheCleanupPeriod;

  @override
  void initState() {
    super.initState();
    _cacheCleanupPeriod = widget.cacheCleanupPeriod;
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
              localizations.cacheSettings,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // 自动清理周期
            Text(localizations.autoCleanupPeriod),
            Text(
              localizations.days,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Slider(
              value: _cacheCleanupPeriod.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              label: '${_cacheCleanupPeriod}${localizations.days}',
              onChanged: (value) {
                setState(() {
                  _cacheCleanupPeriod = value.toInt();
                });
                widget.onCleanupPeriodChanged(_cacheCleanupPeriod);
              },
            ),

            const SizedBox(height: 16),

            // 缓存路径显示
            Text(localizations.cachePath),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                widget.cachePath,
                style: const TextStyle(fontSize: 12),
              ),
            ),

            const SizedBox(height: 16),

            // 清理缓存按钮
            ElevatedButton(
              onPressed: widget.onClearCache,
              child: Text(localizations.clearCacheButton),
            ),
          ],
        ),
      ),
    );
  }
}
