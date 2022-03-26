import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:sim/pages/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash:
        "assets/images/logo.png",
        splashIconSize: 120,
        splashTransition: SplashTransition.fadeTransition,
        nextScreen:LoginScreen(),
      )));

}




/*class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Khazna',
      home: DailyPage(),
    );
  }
}*/

