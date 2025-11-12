import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  final bool autoPlay;

  const VideoPlayerWidget({
    super.key,
    required this.videoPath,
    this.autoPlay = true,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // 初始化视频播放器
    _controller = VideoPlayerController.asset(widget.videoPath);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      // 确保在构建完成后调用setState
      if (mounted) {
        setState(() {});
      }

      // 如果设置为自动播放，则开始播放
      if (widget.autoPlay) {
        _controller.play();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          );
        } else {
          // 显示加载指示器
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF007AFF)),
            ),
          );
        }
      },
    );
  }

  // 控制播放/暂停
  void togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  // 跳转到指定位置
  void seekTo(Duration position) {
    _controller.seekTo(position);
  }

  // 获取当前播放位置
  Duration get currentPosition => _controller.value.position;

  // 获取视频总时长
  Duration get duration => _controller.value.duration;

  // 检查是否正在播放
  bool get isPlaying => _controller.value.isPlaying;
}
