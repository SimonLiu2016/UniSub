import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

class NetworkSettings extends StatefulWidget {
  final bool onlineVideoSupport;
  final int downloadSpeedLimit;
  final String proxyServer;
  final Function(bool, int, String) onSettingsChanged;

  const NetworkSettings({
    super.key,
    required this.onlineVideoSupport,
    required this.downloadSpeedLimit,
    required this.proxyServer,
    required this.onSettingsChanged,
  });

  @override
  State<NetworkSettings> createState() => _NetworkSettingsState();
}

class _NetworkSettingsState extends State<NetworkSettings> {
  late bool _onlineVideoSupport;
  late int _downloadSpeedLimit;
  late String _proxyServer;
  final TextEditingController _proxyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _onlineVideoSupport = widget.onlineVideoSupport;
    _downloadSpeedLimit = widget.downloadSpeedLimit;
    _proxyServer = widget.proxyServer;
    _proxyController.text = _proxyServer;
  }

  @override
  void dispose() {
    _proxyController.dispose();
    super.dispose();
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
              localizations.networkSettings,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // 在线视频支持开关
            SwitchListTile(
              title: Text(localizations.onlineVideoSupport),
              value: _onlineVideoSupport,
              onChanged: (value) {
                setState(() {
                  _onlineVideoSupport = value;
                });
                widget.onSettingsChanged(
                  _onlineVideoSupport,
                  _downloadSpeedLimit,
                  _proxyServer,
                );
              },
            ),

            const SizedBox(height: 16),

            // 下载速度限制
            Text(localizations.downloadSpeedLimit),
            Text(
              localizations.noLimit,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Slider(
              value: _downloadSpeedLimit.toDouble(),
              min: 0,
              max: 10000,
              divisions: 100,
              label: _downloadSpeedLimit == 0
                  ? localizations.noLimit
                  : '${_downloadSpeedLimit}KB/s',
              onChanged: (value) {
                setState(() {
                  _downloadSpeedLimit = value.toInt();
                });
                widget.onSettingsChanged(
                  _onlineVideoSupport,
                  _downloadSpeedLimit,
                  _proxyServer,
                );
              },
            ),

            const SizedBox(height: 16),

            // 代理服务器设置
            Text(localizations.proxyServer),
            TextField(
              controller: _proxyController,
              decoration: InputDecoration(
                hintText: localizations.proxyServerHint,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _proxyServer = value;
                });
                // 延迟更新以避免频繁触发
                Future.delayed(const Duration(milliseconds: 500), () {
                  widget.onSettingsChanged(
                    _onlineVideoSupport,
                    _downloadSpeedLimit,
                    _proxyServer,
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
