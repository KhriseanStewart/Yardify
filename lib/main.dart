import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:yardify/firebase_options.dart';
import 'package:yardify/mobile/database/notification_service.dart';
import 'package:yardify/mobile/database/shared_preference.dart';
import 'package:yardify/routes.dart';
import 'package:yardify/widgets/theme_data.dart';

Future<void> _backgroundMessaging(RemoteMessage message) async {
  NotificationService().backgroundNotification;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make status bar transparent
      statusBarIconBrightness:
          Brightness.dark, // Dark icons for light backgrounds
    ),
  );
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_backgroundMessaging);
    runApp(const MyApp());
  } catch (e) {
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: Text('Firebase init failed: $e'))),
      ),
    );
    print(e);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
    loadThemePreference();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      NotificationService().terminatedApp;
    });
  }

  void loadThemePreference() async {
    bool value = await IsDarkTheme.getBool();
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SoByMarket',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routes: kIsWeb ? WebRouter.webroutes : AppRouter.approutes,
      initialRoute: kIsWeb ? WebRouter.login : AppRouter.getstarted,
    );
  }
}
