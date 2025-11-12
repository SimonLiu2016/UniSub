import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'localization/app_localizations.dart';
import 'views/home_view.dart';
import 'views/settings_page.dart';
import 'views/model_manager_view.dart';
import 'utils/notification_utils.dart';
import 'utils/app_state_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationUtils.initialize();
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
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007AFF),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
        ),
      ),
      themeMode: ThemeMode.dark, // 默认深色模式
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'TW'), // Traditional Chinese
        Locale('zh', 'CN'), // Simplified Chinese
        Locale('en'), // English
        Locale('ja'), // Japanese
        Locale('ko'), // Korean
      ],
      home: const HomeView(),
      routes: {
        '/settings': (context) => const SettingsPage(),
        '/models': (context) => const ModelManagerView(),
      },
    );
  }
}
