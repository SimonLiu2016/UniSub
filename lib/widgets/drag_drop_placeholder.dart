import 'package:flutter/material.dart';

class DragDropPlaceholder extends StatelessWidget {
  final Function(String) onFileDropped;

  const DragDropPlaceholder({super.key, required this.onFileDropped});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library,
            size: 80,
            color: Colors.grey.withOpacity(0.7),
          ),
          const SizedBox(height: 24),
          const Text(
            '拖曳影片至此',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 24,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '或點擊下方按鈕選擇檔案',
            style: TextStyle(color: Colors.grey.withOpacity(0.7), fontSize: 16),
          ),
        ],
      ),
    );
  }
}
