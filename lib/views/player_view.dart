import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../models/subtitle_segment.dart';
import '../widgets/video_player.dart';
import '../widgets/subtitle_player.dart';
import '../widgets/playback_controls.dart';

class PlayerView extends StatefulWidget {
  final String videoPath;
  final List<SubtitleSegment> subtitles;

  const PlayerView({
    super.key,
    required this.videoPath,
    required this.subtitles,
  });

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  late VideoPlayerWidget _videoPlayer;
  double _videoPosition = 0.0;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _videoPlayer = VideoPlayerWidget(videoPath: widget.videoPath);
  }

  @override
  void dispose() {
    // 注意：VideoPlayerWidget 会自己处理控制器的释放
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.appTitle)),
      body: Column(
        children: [
          // 视频播放器
          Expanded(
            child: Stack(
              children: [
                // 视频播放器
                _videoPlayer,

                // 字幕显示
                SubtitlePlayer(
                  subtitles: widget.subtitles,
                  videoPosition: _videoPosition,
                ),
              ],
            ),
          ),

          // 播放控制
          PlaybackControls(
            isPlaying: _isPlaying,
            currentPosition: _currentPosition,
            duration: _duration,
            onPlayPause: _togglePlayPause,
            onPrevious: _skipToPrevious,
            onNext: _skipToNext,
            onFullscreen: _toggleFullscreen,
            onSeek: _seekTo,
          ),
        ],
      ),
    );
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    // 实际的播放/暂停控制需要通过_videoPlayer来实现
  }

  void _skipToPrevious() {
    // 跳转到上一个字幕
  }

  void _skipToNext() {
    // 跳转到下一个字幕
  }

  void _toggleFullscreen() {
    // 切换全屏模式
  }

  void _seekTo(Duration position) {
    setState(() {
      _currentPosition = position;
      _videoPosition = position.inMilliseconds / 1000.0;
    });
    // 实际的跳转控制需要通过_videoPlayer来实现
  }
}
