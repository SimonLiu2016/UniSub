import 'package:flutter/material.dart';

class SubtitleStyleSettings extends StatefulWidget {
  final String fontFamily;
  final double fontSize;
  final Color fontColor;
  final String position;
  final Function(String, double, Color, String) onStyleChanged;

  const SubtitleStyleSettings({
    super.key,
    required this.fontFamily,
    required this.fontSize,
    required this.fontColor,
    required this.position,
    required this.onStyleChanged,
  });

  @override
  State<SubtitleStyleSettings> createState() => _SubtitleStyleSettingsState();
}

class _SubtitleStyleSettingsState extends State<SubtitleStyleSettings> {
  late String _fontFamily;
  late double _fontSize;
  late Color _fontColor;
  late String _position;

  @override
  void initState() {
    super.initState();
    _fontFamily = widget.fontFamily;
    _fontSize = widget.fontSize;
    _fontColor = widget.fontColor;
    _position = widget.position;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 字体选择
        const Text('字体', style: TextStyle(fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          value: _fontFamily,
          items: const [
            DropdownMenuItem(value: 'NotoSansTC', child: Text('思源黑体')),
            DropdownMenuItem(value: 'PingFang', child: Text('苹方')),
            DropdownMenuItem(value: 'Arial', child: Text('Arial')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _fontFamily = value;
              });
              widget.onStyleChanged(
                _fontFamily,
                _fontSize,
                _fontColor,
                _position,
              );
            }
          },
        ),

        const SizedBox(height: 16),

        // 字体大小
        const Text('字体大小', style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: _fontSize,
          min: 12,
          max: 36,
          divisions: 24,
          label: _fontSize.round().toString(),
          onChanged: (value) {
            setState(() {
              _fontSize = value;
            });
            widget.onStyleChanged(
              _fontFamily,
              _fontSize,
              _fontColor,
              _position,
            );
          },
        ),

        const SizedBox(height: 16),

        // 字体颜色
        const Text('字体颜色', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _fontColor,
                border: Border.all(color: Colors.grey),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(onPressed: _pickColor, child: const Text('选择颜色')),
          ],
        ),

        const SizedBox(height: 16),

        // 字幕位置
        const Text('字幕位置', style: TextStyle(fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          value: _position,
          items: const [
            DropdownMenuItem(value: 'top', child: Text('顶部')),
            DropdownMenuItem(value: 'bottom', child: Text('底部')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _position = value;
              });
              widget.onStyleChanged(
                _fontFamily,
                _fontSize,
                _fontColor,
                _position,
              );
            }
          },
        ),
      ],
    );
  }

  void _pickColor() {
    // 颜色选择器实现
    // 这里可以使用 showDialog 显示颜色选择器
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('选择字体颜色'),
          content: SingleChildScrollView(
            child: ColorPicker(
              onColorChanged: (Color color) {
                setState(() {
                  _fontColor = color;
                });
                widget.onStyleChanged(
                  _fontFamily,
                  _fontSize,
                  _fontColor,
                  _position,
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
          ],
        );
      },
    );
  }
}

// 简单的颜色选择器组件
class ColorPicker extends StatelessWidget {
  final Function(Color) onColorChanged;

  const ColorPicker({super.key, required this.onColorChanged});

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Colors.white,
      Colors.black,
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: colors.map((color) {
        return GestureDetector(
          onTap: () => onColorChanged(color),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.grey),
            ),
          ),
        );
      }).toList(),
    );
  }
}
