import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../localization/app_localizations.dart';
import '../services/audio_service.dart';
import '../services/youtube_service.dart';
import '../utils/file_utils.dart';
import '../utils/clipboard_utils.dart';
import '../utils/app_state_manager.dart';
import '../widgets/processing_progress.dart';
import '../widgets/drag_drop_area.dart';
import '../widgets/url_input_field.dart';
import '../widgets/file_picker_button.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? _selectedFilePath;
  String? _videoUrl;
  final TextEditingController _urlController = TextEditingController();

  final AudioService _audioService = AudioService();
  final YoutubeService _youtubeService = YoutubeService();

  @override
  void initState() {
    super.initState();
    _startClipboardMonitoring();
  }

  @override
  void dispose() {
    _urlController.dispose();
    ClipboardUtils.stopClipboardMonitoring();
    super.dispose();
  }

  void _startClipboardMonitoring() {
    ClipboardUtils.startClipboardMonitoring((url) {
      if (mounted) {
        setState(() {
          _urlController.text = url;
        });

        // 显示提示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('检测到视频链接已自动填充'),
            action: SnackBarAction(
              label: '使用',
              onPressed: () => _onUrlSubmitted(url),
            ),
          ),
        );
      }
    });
  }

  void _onFileSelected(String filePath) {
    final appState = Provider.of<AppStateManager>(context, listen: false);
    appState.startProcessing('正在处理文件...');

    setState(() {
      _selectedFilePath = filePath;
    });

    // 模拟处理过程
    Future.delayed(const Duration(seconds: 3), () {
      appState.finishProcessing();
    });
  }

  void _onUrlSubmitted(String url) {
    if (!_youtubeService.isValidYoutubeUrl(url) &&
        !_youtubeService.isValidBilibiliUrl(url)) {
      // 显示错误提示
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('不支持的视频链接')));
      return;
    }

    final appState = Provider.of<AppStateManager>(context, listen: false);
    appState.startProcessing('正在下载音频...');

    setState(() {
      _videoUrl = url;
    });

    // 模拟处理过程
    Future.delayed(const Duration(seconds: 3), () {
      appState.updateProgress(0.5, '正在转写...');
      Future.delayed(const Duration(seconds: 3), () {
        appState.finishProcessing();
      });
    });
  }

  Future<void> _pickFile() async {
    final filePath = await FileUtils.pickFile();
    if (filePath != null) {
      _onFileSelected(filePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final appState = Provider.of<AppStateManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // 导航到设置页面
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Center(
        child: appState.isProcessing
            ? _buildProcessingView(localizations, appState)
            : _buildInputView(localizations),
      ),
    );
  }

  Widget _buildProcessingView(
    AppLocalizations localizations,
    AppStateManager appState,
  ) {
    return ProcessingProgress(
      progress: appState.processingProgress,
      status: appState.processingStatus,
      detail: _selectedFilePath != null
          ? localizations.transcribing
          : localizations.downloadAudio,
    );
  }

  Widget _buildInputView(AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 拖拽区域
          DragDropArea(
            hintText: localizations.dragHint,
            onFileDropped: _onFileSelected,
          ),
          const SizedBox(height: 16),
          Text(localizations.orText),
          const SizedBox(height: 16),
          // 文件选择按钮
          FilePickerButton(
            text: localizations.selectFile,
            onPressed: _pickFile,
          ),
          const SizedBox(height: 16),
          // URL输入
          UrlInputField(
            hintText: localizations.pasteUrl,
            onUrlSubmitted: _onUrlSubmitted,
          ),
        ],
      ),
    );
  }
}
