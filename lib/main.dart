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
import 'constants/app_constants.dart';

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

class UniSubApp extends StatefulWidget {
  const UniSubApp({super.key});

  @override
  State<UniSubApp> createState() => _UniSubAppState();
}

class _UniSubAppState extends State<UniSubApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniSub',
      locale: _locale,
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
        Locale('zh', 'TW'), // Traditional Chinese
        Locale('en'), // English
        Locale('ja'), // Japanese
        Locale('ko'), // Korean
        Locale('fr'), // French
        Locale('es'), // Spanish
        Locale('pt'), // Portuguese
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // 使用当前设置的语言
        return _locale;
      },
      home: HomeView(onLocaleChanged: setLocale),
      routes: {
        '/settings': (context) => SettingsPage(onLocaleChanged: setLocale),
        '/models': (context) => const ModelManagerView(),
      },
    );
  }
}
