import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

class AboutDialogWidget extends StatelessWidget {
  const AboutDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AlertDialog(
      title: const Text('关于 UniSub'),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 应用图标
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFF007AFF),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.subtitles, color: Colors.white, size: 32),
              ),
            ),
            const SizedBox(height: 16),

            // 应用名称和版本
            const Text(
              'UniSub',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            const Text('v1.2.0', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),

            // 描述
            const Text('全离线优先的 AI 字幕生成工具', textAlign: TextAlign.center),
            const SizedBox(height: 16),

            // 版权信息
            const Text(
              '© 2025 UniSub. 保留所有权利。',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(localizations.play),
        ),
      ],
    );
  }
}
