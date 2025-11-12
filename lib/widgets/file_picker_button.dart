import 'package:flutter/material.dart';

class FilePickerButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;

  const FilePickerButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon = Icons.file_open,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
    );
  }
}
