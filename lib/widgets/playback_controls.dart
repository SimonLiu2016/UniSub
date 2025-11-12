import 'package:flutter/material.dart';

class PlaybackControls extends StatelessWidget {
  final bool isPlaying;
  final Duration currentPosition;
  final Duration duration;
  final VoidCallback onPlayPause;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onFullscreen;
  final Function(Duration) onSeek;

  const PlaybackControls({
    super.key,
    required this.isPlaying,
    required this.currentPosition,
    required this.duration,
    required this.onPlayPause,
    required this.onPrevious,
    required this.onNext,
    required this.onFullscreen,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 进度条
        Slider(
          value: currentPosition.inMilliseconds.toDouble(),
          min: 0,
          max: duration.inMilliseconds.toDouble(),
          onChanged: (value) {
            onSeek(Duration(milliseconds: value.toInt()));
          },
        ),
        // 时间显示
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(currentPosition)),
              Text(_formatDuration(duration)),
            ],
          ),
        ),
        // 控制按钮
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.skip_previous),
              onPressed: onPrevious,
            ),
            IconButton(
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: onPlayPause,
            ),
            IconButton(icon: const Icon(Icons.skip_next), onPressed: onNext),
            IconButton(
              icon: const Icon(Icons.fullscreen),
              onPressed: onFullscreen,
            ),
          ],
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
