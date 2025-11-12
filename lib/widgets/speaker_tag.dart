import 'package:flutter/material.dart';

class SpeakerTag extends StatefulWidget {
  final String speaker;
  final Function(String) onSpeakerChanged;
  final bool isEditable;

  const SpeakerTag({
    super.key,
    required this.speaker,
    required this.onSpeakerChanged,
    this.isEditable = true,
  });

  @override
  State<SpeakerTag> createState() => _SpeakerTagState();
}

class _SpeakerTagState extends State<SpeakerTag> {
  late String _speaker;
  bool _isEditing = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _speaker = widget.speaker;
    _controller.text = _speaker;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 100,
            child: TextField(
              controller: _controller,
              onSubmitted: (value) => _submitEdit(),
              autofocus: true,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check, size: 16),
            onPressed: _submitEdit,
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: _cancelEdit,
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: widget.isEditable ? _startEditing : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_speaker),
            if (widget.isEditable)
              const Icon(Icons.edit, size: 12, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _submitEdit() {
    setState(() {
      _speaker = _controller.text;
      _isEditing = false;
    });
    widget.onSpeakerChanged(_speaker);
  }

  void _cancelEdit() {
    _controller.text = _speaker;
    setState(() {
      _isEditing = false;
    });
  }
}
