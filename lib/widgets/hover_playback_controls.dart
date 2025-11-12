import 'package:flutter/material.dart';

class HoverPlaybackControls extends StatefulWidget {
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onFullscreen;

  const HoverPlaybackControls({
    super.key,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onPrevious,
    required this.onNext,
    required this.onFullscreen,
  });

  @override
  State<HoverPlaybackControls> createState() => _HoverPlaybackControlsState();
}

class _HoverPlaybackControlsState extends State<HoverPlaybackControls> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isVisible = true),
      onExit: (_) => setState(() => _isVisible = false),
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.skip_previous,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: widget.onPrevious,
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(
                  widget.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 48,
                ),
                onPressed: widget.onPlayPause,
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(
                  Icons.skip_next,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: widget.onNext,
              ),
              const SizedBox(width: 32),
              IconButton(
                icon: const Icon(
                  Icons.fullscreen,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: widget.onFullscreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
