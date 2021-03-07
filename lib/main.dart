import 'package:JapanThaiExpress/Screens/Login/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';


GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
  OneSignal.shared.init("a272f0a4-295a-4f8f-8f2d-604d56718117", iOSSettings: {
    OSiOSSettings.autoPrompt: false,
    OSiOSSettings.inAppLaunchUrl: false
  });
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);
  OneSignal.shared
      .setNotificationReceivedHandler((OSNotification notification) {
    // will be called whenever a notification is received
  });

  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);
  // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  await OneSignal.shared
      .promptUserForPushNotificationPermission(fallbackToSettings: true);

  OneSignal.shared
      .setNotificationReceivedHandler((OSNotification notification) {
    // will be called whenever a notification is received
  });

  // OneSignal.shared
  //     .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
  //   // will be called whenever a notification is opened/button pressed.
  //   navigatorKey.currentState
  //       .pushNamed(result.notification.payload.additionalData['/home']);
  // });

  var status = await OneSignal.shared.getPermissionSubscriptionState();
  String playerId = status.subscriptionStatus.userId;  
  print(playerId);
  // await OneSignal.shared.postNotification(OSCreateNotification(
  //   playerIds: [playerId],
  //   content: "this is a test from OneSignal's Flutter SDK",
  //   heading: "Test Notification",
  //   buttons: [
  //     OSActionButton(text: "test1", id: "id1"),

  //   ]
  // ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'JapnExpress',
        theme: ThemeData(
          //primarySwatch: Colors.grey,
          primaryColor: Color(0xffdd4b39),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (context) => LoginScreen(),
        });
  }
}
