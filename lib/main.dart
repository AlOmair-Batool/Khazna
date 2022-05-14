import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sim/Pages/local_notify_manager.dart';
import 'package:sim/pages/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await localNotifyManager.showNotification(ReceiveNotification(title: message.notification!.title,body: message.notification!.body));
//   print('Handling a background message ${message.messageId}');
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("ee1f8183-0c44-4ddb-b2d7-25fe43aafa7c");

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission

  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
  // await FirebaseMessaging.instance.requestPermission(
  //     sound: true,
  //     provisional: true,
  //     criticalAlert: true,
  //     carPlay: true,
  //     badge: true,
  //     announcement: true,
  //     alert: true
  // );
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // await FirebaseMessaging.instance
  //     .setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
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


