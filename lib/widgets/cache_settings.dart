import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../localization/app_localizations.dart';
import '../services/audio_service.dart'; // 导入音频服务

class CacheSettings extends StatefulWidget {
  final int cacheCleanupPeriod;
  final String cachePath;
  final Function(int) onCleanupPeriodChanged;
  final Function() onClearCache;
  final AudioService? audioService; // 添加音频服务参数

  const CacheSettings({
    super.key,
    required this.cacheCleanupPeriod,
    required this.cachePath,
    required this.onCleanupPeriodChanged,
    required this.onClearCache,
    this.audioService, // 添加音频服务参数
  });

  @override
  State<CacheSettings> createState() => _CacheSettingsState();
}

class _CacheSettingsState extends State<CacheSettings> {
  late int _cacheCleanupPeriod;
  String? _audioDirectoryPath; // 音频目录路径

  @override
  void initState() {
    super.initState();
    _cacheCleanupPeriod = widget.cacheCleanupPeriod;
    _loadAudioDirectoryPath(); // 加载音频目录路径
  }

  // 加载音频目录路径
  Future<void> _loadAudioDirectoryPath() async {
    if (widget.audioService != null) {
      try {
        final audioDir = await widget.audioService!.getAudioDirectory();
        setState(() {
          _audioDirectoryPath = audioDir.path;
        });
      } catch (e) {
        // 处理错误
        setState(() {
          _audioDirectoryPath = '无法获取音频目录';
        });
      }
    }
  }

  // 打开音频目录
  Future<void> _openAudioDirectory() async {
    if (_audioDirectoryPath != null &&
        await Directory(_audioDirectoryPath!).exists()) {
      final uri = Uri.parse('file://${_audioDirectoryPath!}');
      if (await canLaunch(uri.toString())) {
        await launch(uri.toString());
      } else {
        // 显示错误消息
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('无法打开目录: $_audioDirectoryPath')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
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

            // 音频文件目录显示（如果有音频服务）
            if (widget.audioService != null) ...[
              Text('音频文件目录'),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _audioDirectoryPath ?? '加载中...',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _openAudioDirectory,
                child: const Text('打开音频目录'),
              ),
              const SizedBox(height: 16),
            ],

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
