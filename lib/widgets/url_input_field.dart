import 'package:flutter/material.dart';

class UrlInputField extends StatefulWidget {
  final String hintText;
  final Function(String) onUrlSubmitted;

  const UrlInputField({
    super.key,
    required this.hintText,
    required this.onUrlSubmitted,
  });

  @override
  State<UrlInputField> createState() => _UrlInputFieldState();
}

class _UrlInputFieldState extends State<UrlInputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onUrlSubmitted(_controller.text);
            }
          },
        ),
      ),
      onSubmitted: widget.onUrlSubmitted,
    );
  }
}
