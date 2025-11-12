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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
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
