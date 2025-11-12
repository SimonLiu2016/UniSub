import 'package:flutter/material.dart';

class FileInfoDisplay extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final String fileType;
  final String duration;

  const FileInfoDisplay({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.fileType,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.description),
                const SizedBox(width: 8),
                Text(fileName, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildInfoItem(context, '大小', fileSize),
                const SizedBox(width: 16),
                _buildInfoItem(context, '类型', fileType),
                const SizedBox(width: 16),
                _buildInfoItem(context, '时长', duration),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Row(
      children: [
        Text('$label: ', style: Theme.of(context).textTheme.bodySmall),
        Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
