import 'package:ahmed_academy/Settings/theme/theme.dart';
import 'package:ahmed_academy/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:motion/motion.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
   
   await dotenv.load();

  String apiKey = dotenv.env['API_KEY']! ;
  String appId = dotenv.env['APP_ID']!;
  String messagingSenderId = dotenv.env["MESSAGING_SENDER_ID"]!;
  String projectId = dotenv.env["PROJECT_ID"]!;

  await Firebase.initializeApp(
    options:  FirebaseOptions(
        apiKey: apiKey,
        appId: appId,
        messagingSenderId: messagingSenderId,
        projectId: projectId),
  );
  await Future.delayed(const Duration(seconds: 2));
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorSchemeSeed: CustomTheme().selectedTextColor,
          scaffoldBackgroundColor: Colors.grey[150]),
      home: HomeScreen(),
    );
  }
}
