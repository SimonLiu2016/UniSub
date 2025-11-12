import 'package:flutter/material.dart';

class ModelSelector extends StatelessWidget {
  final String selectedModel;
  final Function(String) onModelChanged;
  final List<Map<String, dynamic>> models;

  const ModelSelector({
    super.key,
    required this.selectedModel,
    required this.onModelChanged,
    required this.models,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedModel,
      items: models.map((model) {
        return DropdownMenuItem<String>(
          value: model['name'],
          child: Text('${model['displayName']} (${model['size']}MB)'),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          onModelChanged(value);
        }
      },
    );
  }
}
