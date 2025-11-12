import 'package:flutter/material.dart';

class ModelItem extends StatelessWidget {
  final String name;
  final String displayName;
  final int size;
  final bool isDownloaded;
  final VoidCallback? onDownload;
  final VoidCallback? onDelete;

  const ModelItem({
    super.key,
    required this.name,
    required this.displayName,
    required this.size,
    required this.isDownloaded,
    this.onDownload,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(displayName),
        subtitle: Text('${size}MB'),
        trailing: isDownloaded
            ? IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              )
            : ElevatedButton(onPressed: onDownload, child: const Text('下载')),
      ),
    );
  }
}
