import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:unisub/main.dart';
import 'package:unisub/utils/app_state_manager.dart';

void main() {
  group('App Integration Tests', () {
    testWidgets('should display home screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => AppStateManager(),
          child: const UniSubApp(),
        ),
      );

      // 验证应用标题存在
      expect(find.text('UniSub'), findsOneWidget);

      // 验证文件选择按钮存在
      expect(find.byIcon(Icons.file_open), findsOneWidget);

      // 验证URL输入框存在
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should navigate to settings screen', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => AppStateManager(),
          child: const UniSubApp(),
        ),
      );

      // 点击设置按钮
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // 验证设置页面标题存在
      expect(find.text('设置'), findsOneWidget);
    });
  });
}
