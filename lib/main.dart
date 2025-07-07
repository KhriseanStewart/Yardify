import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yardify/firebase_options.dart';
import 'package:yardify/routes.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
      routes: kIsWeb ? WebRouter.webroutes : AppRouter.approutes,
      initialRoute: kIsWeb ? WebRouter.login : AppRouter.authgate,
    );
  }
}
