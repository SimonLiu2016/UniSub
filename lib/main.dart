import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'localization/app_localizations.dart';
import 'views/home_view.dart';
import 'views/settings_page.dart';
import 'views/model_manager_view.dart';
import 'utils/notification_utils.dart';
import 'utils/app_state_manager.dart';
import 'utils/system_tray.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationUtils.initialize();
  await SystemTray.initialize(); // 初始化系统托盘
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppStateManager(),
      child: const UniSubApp(),
    ),
  );
}

class UniSubApp extends StatelessWidget {
  const UniSubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniSub',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007AFF),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF007AFF),
          foregroundColor: Colors.white,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        listTileTheme: const ListTileThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007AFF),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: null,
        appBarTheme: const AppBarTheme(
          backgroundColor: null,
          foregroundColor: Colors.white,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        listTileTheme: const ListTileThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      themeMode: ThemeMode.light, // 默认浅色模式
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'CN'), // Simplified Chinese
        Locale('en'), // English
        Locale('ja'), // Japanese
        Locale('ko'), // Korean
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // 默认使用英文
        return const Locale('en');
      },
      home: const HomeView(),
      routes: {
        '/settings': (context) => const SettingsPage(),
        '/models': (context) => const ModelManagerView(),
      },
    );
  }
}
