import 'package:flutter/material.dart';

class DragDropArea extends StatelessWidget {
  final String hintText;
  final Function(String) onFileDropped;

  const DragDropArea({
    super.key,
    required this.hintText,
    required this.onFileDropped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DragTarget<String>(
        builder: (context, candidateItems, rejectedItems) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.upload_file, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                hintText,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
        onAcceptWithDetails: (details) {
          onFileDropped(details.data);
        },
      ),
    );
  }
}
