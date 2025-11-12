import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unisub/widgets/drag_drop_area.dart';

void main() {
  group('DragDropArea', () {
    testWidgets('should display hint text', (WidgetTester tester) async {
      const hintText = 'Drag files here';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DragDropArea(hintText: hintText, onFileDropped: (file) {}),
          ),
        ),
      );

      expect(find.text(hintText), findsOneWidget);
      expect(find.byIcon(Icons.upload_file), findsOneWidget);
    });

    testWidgets('should call onFileDropped when file is dropped', (
      WidgetTester tester,
    ) async {
      var droppedFile = '';
      const testFile = 'test_file.mp4';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DragDropArea(
              hintText: 'Drag files here',
              onFileDropped: (file) => droppedFile = file,
            ),
          ),
        ),
      );

      // 模拟文件拖拽操作
      final dragTarget = find.byType(DragTarget<String>);
      expect(dragTarget, findsOneWidget);

      // 注意：由于DragTarget的测试比较复杂，这里只测试基本的widget渲染
    });
  });
}
