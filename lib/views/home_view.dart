import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:file_picker/file_picker.dart'; // 未使用的导入
import '../localization/app_localizations.dart';
import '../services/youtube_service.dart';
// import '../services/audio_service.dart'; // 未使用的导入
import '../utils/app_state_manager.dart';
import '../utils/file_utils.dart';
import '../utils/clipboard_utils.dart';
import '../models/subtitle_segment.dart';
import '../widgets/drag_drop_placeholder.dart';
import '../widgets/video_player.dart';
import '../widgets/subtitle_player.dart';
import '../widgets/subtitle_timeline.dart';
import '../widgets/hover_playback_controls.dart';
// import '../services/video_detector.dart'; // 未使用的导入

class HomeView extends StatefulWidget {
  final Function(Locale)? onLocaleChanged;

  const HomeView({super.key, this.onLocaleChanged});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? _selectedFilePath;
  String? _videoUrl;
  final TextEditingController _urlController = TextEditingController();
  VideoPlayerWidget? _videoPlayer; // 改为可空类型，移除late
  double _videoPosition = 0.0;
  bool _isPlaying = false;
  bool _isTimelineCollapsed = false;
  List<SubtitleSegment> _subtitles = [];
  int _currentSubtitleIndex = -1;

  // final AudioService _audioService = AudioService(); // 未使用的字段
  final VideoService _videoService = VideoService(); // 新的视频服务

  @override
  void initState() {
    super.initState();
    _startClipboardMonitoring();
    _initializeSampleSubtitles();
  }

  @override
  void dispose() {
    _urlController.dispose();
    ClipboardUtils.stopClipboardMonitoring();
    super.dispose();
  }

  void _initializeSampleSubtitles() {
    // 创建示例字幕数据用于演示
    _subtitles = [
      SubtitleSegment(
        id: 1,
        startTime: 83.0,
        endTime: 88.0,
        text: '今天天氣真好，我們來聊聊 AI 字幕吧～',
        speaker: '講者1',
      ),
      SubtitleSegment(
        id: 2,
        startTime: 89.0,
        endTime: 95.0,
        text: '對啊！尤其是台灣口音的辨識真的越來越準了！',
        speaker: '講者2',
      ),
      SubtitleSegment(
        id: 3,
        startTime: 96.0,
        endTime: 102.0,
        text: '而且還能自動區分說話人，超級方便！',
        speaker: '講者1',
      ),
    ];
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
      // 处理完成后初始化视频播放器
      setState(() {
        _videoPlayer = VideoPlayerWidget(videoPath: filePath);
      });
    });
  }

  void _onUrlSubmitted(String url) {
    if (!_videoService.isSupportedPlatform(url)) {
      // 显示错误提示
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('不支持的视频链接')));
      return;
    }

    final appState = Provider.of<AppStateManager>(context, listen: false);
    appState.startProcessing('正在解析视频信息...');

    setState(() {
      _videoUrl = url;
    });

    // 启动处理流程
    _processVideoUrl(url, appState);
  }

  /// 处理视频URL的完整流程
  Future<void> _processVideoUrl(String url, AppStateManager appState) async {
    try {
      debugPrint('开始处理视频URL: $url');

      // 1. 获取视频信息
      appState.updateProgress(0.1, '正在获取视频信息...');
      final videoInfo = await _videoService.getVideoInfo(url);
      debugPrint('获取视频信息成功: $videoInfo');

      // 2. 下载音频
      appState.updateProgress(0.2, '正在下载音频...');
      final videoPath = await _videoService.downloadVideo(url, (
        progress,
        status,
      ) {
        // 更新进度
        final adjustedProgress = 0.2 + (progress * 0.6); // 20%到80%的范围
        appState.updateProgress(adjustedProgress, status);
        debugPrint('下载进度: $progress, 状态: $status');
      });
      debugPrint('视频下载成功，路径: $videoPath');

      // 3. 转写音频
      appState.updateProgress(0.8, '正在转写音频...');
      await Future.delayed(const Duration(seconds: 2)); // 模拟转写过程
      debugPrint('音频转写完成');

      // 4. 完成处理
      appState.finishProcessing();
      debugPrint('处理流程完成');

      // 处理完成后初始化视频播放器
      setState(() {
        _videoPlayer = VideoPlayerWidget(videoPath: videoPath);
      });
    } catch (e) {
      debugPrint('处理视频URL时发生错误: $e');

      // 处理错误
      appState.finishProcessing();

      // 重置进度为0，表示处理失败
      appState.updateProgress(0.0, '处理失败');

      String errorMessage = e.toString();

      // 提供更友好的错误提示
      if (errorMessage.contains('执行失败')) {
        errorMessage = '视频处理失败: ${errorMessage.replaceAll('Exception:', '')}';
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('处理失败: $errorMessage')));
      }
    }
  }

  Future<void> _pickFile() async {
    final filePath = await FileUtils.pickFile();
    if (filePath != null) {
      _onFileSelected(filePath);
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    // 实际的播放/暂停控制需要通过_videoPlayer来实现
  }

  void _toggleTimeline() {
    setState(() {
      _isTimelineCollapsed = !_isTimelineCollapsed;
    });
  }

  void _onSubtitleTap(int index) {
    setState(() {
      _currentSubtitleIndex = index;
      // 跳转到对应时间点
      if (index < _subtitles.length) {
        _videoPosition = _subtitles[index].startTime;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final appState = Provider.of<AppStateManager>(context);

    return Scaffold(
      backgroundColor: null,
      body: Column(
        children: [
          // 顶部工具栏 - 添加顶部安全边距以避免与系统控件重叠
          Container(
            padding: const EdgeInsets.only(top: 20), // 添加顶部边距
            child: _buildTopBar(localizations),
          ),

          // 主内容区
          Expanded(
            child: appState.isProcessing
                ? _buildProcessingView(localizations, appState)
                : _selectedFilePath != null || _videoUrl != null
                ? _buildPlayerView()
                : _buildInputView(localizations),
          ),

          // 底部状态栏
          _buildStatusBar(appState),
        ],
      ),
    );
  }

  Widget _buildTopBar(AppLocalizations localizations) {
    final theme = Theme.of(context);

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 16),
            child: Text(
              'UniSub',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // URL输入框
          Expanded(
            child: Container(
              height: 36,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(18),
              ),
              child: TextField(
                controller: _urlController,
                style: TextStyle(
                  color: theme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: localizations.pasteUrl,
                  hintStyle: TextStyle(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: theme.brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black54,
                    ),
                    onPressed: () {
                      if (_urlController.text.isNotEmpty) {
                        _onUrlSubmitted(_urlController.text);
                      }
                    },
                  ),
                ),
                onSubmitted: _onUrlSubmitted,
              ),
            ),
          ),

          // 实时翻译开关
          IconButton(
            icon: Icon(
              Icons.flash_on,
              color: theme.brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black54,
            ),
            onPressed: () {
              // TODO: 实现实时翻译开关功能
            },
          ),

          // 语言切换
          PopupMenuButton<String>(
            icon: Icon(
              Icons.language,
              color: theme.brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black54,
            ),
            onSelected: (String language) {
              // 调用父组件的回调来更新语言
              if (widget.onLocaleChanged != null) {
                // 根据语言代码创建对应的Locale对象
                Locale locale;
                switch (language) {
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
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'zh_CN', child: Text('简体中文')),
              const PopupMenuItem(value: 'zh_TW', child: Text('繁體中文')),
              const PopupMenuItem(value: 'en', child: Text('English')),
              const PopupMenuItem(value: 'ja', child: Text('日本語')),
              const PopupMenuItem(value: 'ko', child: Text('한국어')),
              const PopupMenuItem(value: 'fr', child: Text('Français')),
              const PopupMenuItem(value: 'es', child: Text('Español')),
              const PopupMenuItem(value: 'pt', child: Text('Português')),
              const PopupMenuItem(value: 'ar', child: Text('العربية')),
              const PopupMenuItem(value: 'hi', child: Text('हिन्दी')),
              const PopupMenuItem(value: 'bn', child: Text('বাংলা')),
              const PopupMenuItem(value: 'de', child: Text('Deutsch')),
              const PopupMenuItem(value: 'ru', child: Text('Русский')),
            ],
          ),

          // 设置按钮
          IconButton(
            icon: Icon(
              Icons.settings,
              color: theme.brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black54,
            ),
            onPressed: () {
              // 导航到设置页面
              Navigator.pushNamed(context, '/settings');
            },
          ),

          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildProcessingView(
    AppLocalizations localizations,
    AppStateManager appState,
  ) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            value: appState.processingProgress,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF007AFF)),
            strokeWidth: 6,
          ),
          const SizedBox(height: 24),
          Text(
            appState.processingStatus,
            style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedFilePath != null
                ? localizations.transcribing
                : localizations.downloadAudio,
            style: TextStyle(
              color: theme.brightness == Brightness.dark
                  ? Colors.grey
                  : Colors.black54,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${(appState.processingProgress * 100).round()}%',
            style: TextStyle(
              color: theme.brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black54,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputView(AppLocalizations localizations) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 拖拽区域占位图
            DragDropPlaceholder(onFileDropped: _onFileSelected),
            const SizedBox(height: 32),
            // 文件选择按钮
            ElevatedButton.icon(
              onPressed: _pickFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: Icon(
                Icons.file_open,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
              label: Text(
                localizations.selectFile,
                style: TextStyle(
                  color: theme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerView() {
    final theme = Theme.of(context);

    return Column(
      children: [
        // 视频播放器区域 (70% 高度)
        Expanded(
          flex: 7,
          child: Stack(
            children: [
              // 视频播放器
              if (_videoPlayer != null) _videoPlayer! else Container(),

              // 字幕悬浮层
              SubtitlePlayer(
                subtitles: _subtitles,
                videoPosition: _videoPosition,
                fontFamily: 'NotoSansTC',
                fontSize: 18.0,
                position: 'bottom',
              ),

              // 悬停播放控件
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: HoverPlaybackControls(
                  isPlaying: _isPlaying,
                  onPlayPause: _togglePlayPause,
                  onPrevious: () {
                    // TODO: 实现跳转到上一个字幕
                  },
                  onNext: () {
                    // TODO: 实现跳转到下一个字幕
                  },
                  onFullscreen: () {
                    // TODO: 实现全屏功能
                  },
                ),
              ),
            ],
          ),
        ),

        // 字幕时间轴面板 (30% 高度，可折叠)
        Expanded(
          flex: _isTimelineCollapsed ? 0 : 3,
          child: Column(
            children: [
              // 折叠按钮
              GestureDetector(
                onTap: _toggleTimeline,
                child: Container(
                  height: 20,
                  color: theme.colorScheme.surface,
                  child: Icon(
                    _isTimelineCollapsed
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    color: theme.brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54,
                  ),
                ),
              ),

              // 字幕时间轴
              if (!_isTimelineCollapsed)
                Expanded(
                  child: SubtitleTimeline(
                    subtitles: _subtitles,
                    currentSubtitleIndex: _currentSubtitleIndex,
                    onSubtitleTap: _onSubtitleTap,
                    onSubtitleEdit: (int index, String text) {
                      // TODO: 实现字幕编辑功能
                    },
                    onSpeakerEdit: (int index, String speaker) {
                      // TODO: 实现说话人编辑功能
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBar(AppStateManager appState) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // 进度指示
          const SizedBox(width: 16),
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              value: appState.isProcessing ? appState.processingProgress : 0,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF007AFF),
              ),
              strokeWidth: 3,
            ),
          ),

          const SizedBox(width: 12),

          // 状态文本
          Expanded(
            child: Text(
              appState.isProcessing
                  ? appState.processingStatus
                  : localizations.ready,
              style: TextStyle(
                color: theme.brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black54,
                fontSize: 14,
              ),
            ),
          ),

          // 导出按钮
          TextButton(
            onPressed: () {
              // TODO: 实现导出功能
            },
            child: Text(
              '↓ ${localizations.exportSubtitle} SRT',
              style: TextStyle(
                color: theme.brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black54,
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(width: 16),
        ],
      ),
    );
  }

  /// 处理URL输入
  // Future<void> _handleUrlInput(String url) async {
  //   final appState = Provider.of<AppStateManager>(context, listen: false);
  //   appState.startProcessing('正在处理URL...');
  //
  //   try {
  //     // 首先检测URL对应的页面是否有视频
  //     appState.updateProgress(0.05, '正在检测页面视频内容...');
  //     final videoInfo = await VideoDetector.getVideoInfo(url);
  //
  //     if (!videoInfo['hasVideo']) {
  //       // 如果没有检测到视频，显示错误信息
  //       appState.finishProcessing();
  //       appState.updateProgress(0.0, '未检测到视频内容');
  //
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('未在页面中检测到视频内容: ${videoInfo['error'] ?? '未知错误'}'),
  //           ),
  //         );
  //       }
  //       return;
  //     }
  //
  //     // 如果检测到视频，继续处理
  //     debugPrint('检测到视频内容: ${videoInfo['title']}');
  //     appState.updateProgress(0.1, '检测到视频内容，开始处理...');
  //
  //     // 延迟一小段时间让用户看到检测结果
  //     await Future.delayed(const Duration(milliseconds: 500));
  //
  //     // 继续处理视频URL
  //     await _processVideoUrl(url, appState);
  //   } catch (e) {
  //     debugPrint('处理URL输入时发生错误: $e');
  //     appState.finishProcessing();
  //     appState.updateProgress(0.0, '处理失败');
  //
  //     if (mounted) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text('处理失败: $e')));
  //     }
  //   }
  // }
}
