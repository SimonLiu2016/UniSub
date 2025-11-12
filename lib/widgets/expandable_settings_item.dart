import 'package:flutter/material.dart';

class ExpandableSettingsItem extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ExpandableSettingsItem({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(title: Text(title), children: children);
  }
}
