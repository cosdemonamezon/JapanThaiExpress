import 'dart:io';
import 'package:JapanThaiExpress/Screens/Login/SplashScreen.dart';
import 'package:JapanThaiExpress/Screens/Login/LoginPin.dart';
import 'package:JapanThaiExpress/Screens/Login/LoginScreen.dart';
import 'package:JapanThaiExpress/Screens/Login/SetPinScreen.dart';
import 'package:JapanThaiExpress/Screens/Login/intro_screen.dart';
import 'package:JapanThaiExpress/Screens/Login/home_screen.dart';
import 'package:JapanThaiExpress/Screens/Register/RegisterScreen.dart';
import 'package:JapanThaiExpress/Screens/Login/ForgotScreen.dart';

import 'package:JapanThaiExpress/AdminScreens/Home/HomeScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/Deposit/DepositDetailScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/QRCodeScan/QRCodePreview.dart';
import 'package:JapanThaiExpress/AdminScreens/PreOders/TimeLineScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/PreOders/TimeLinePurchaseScreen.dart';
import 'package:JapanThaiExpress/Screens/Register/SetPin.dart';
import 'package:JapanThaiExpress/UserScreens/Dashboard/DashbordScreen.dart';
import 'package:JapanThaiExpress/UserScreens/News/DetailNews.dart';
import 'package:JapanThaiExpress/UserScreens/News/NewsScreen.dart';
import 'package:JapanThaiExpress/UserScreens/Profile/ProfileScreen.dart';
import 'package:JapanThaiExpress/UserScreens/Service/Deposit.dart';
import 'package:JapanThaiExpress/UserScreens/Service/ReceiveMoney.dart';
import 'package:JapanThaiExpress/UserScreens/Service/Service.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:JapanThaiExpress/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AdminScreens/Home/HomeScreen.dart';
import 'AdminScreens/Home/HomeScreen.dart';
import 'Screens/Login/ForgotScreen.dart';
import 'Screens/Register/RegisterScreen.dart';

import 'package:JapanThaiExpress/LoginFB.dart';
import 'package:JapanThaiExpress/LoginGoogle.dart';

String token;
var tokenObj;
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
String routePath = '/';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // token = prefs.getString('token');
  // tokenObj = convert.jsonDecode(token);

  SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.bottom, SystemUiOverlay.top]);

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
  runApp(MyApp());
}

var routes = <String, WidgetBuilder>{
  '/': (context) => token == null
      ? SplashScreen()
      : tokenObj['data']['type'] == 'admin'
          ? HomeScreen()
          : DashbordScreen(),
  "/adminhome": (BuildContext context) => HomeScreen(),
  "/memberhome": (BuildContext context) => DashbordScreen(),
  "/intro": (BuildContext context) => IntroScreen(),
  "/login": (BuildContext context) => LoginScreen(),
  "/pinverify": (BuildContext context) => LoginPin(),
  "/forgot": (BuildContext context) => ForgotScreen(),
  "/register": (BuildContext context) => RegisterScreen(),
  "/depositdetail": (BuildContext context) => DepositDetailScreen(),
  "/qrcodepreview": (BuildContext context) => QRCodePreview(),
  "/timelineorders": (BuildContext context) => TimeLineScreen(),
  "/timelineorderspurchase": (BuildContext context) => TimeLinePurchaseScreen(),
<<<<<<< HEAD
=======
  "/deposit": (BuildContext context) => Deposit(),
  "/news": (BuildContext context) => NewsScreen(),
  "/newsdetail": (BuildContext context) => DetailNews(),
  "/service": (BuildContext context) => Service(),
  "/receivemoney": (BuildContext context) => ReceiveMoney(),
  "/profile": (BuildContext context) => ProfileScreen(),
  "/goback": (BuildContext context) => DashbordScreen(),
>>>>>>> f1169f7e514260cb98370d564e84809620c87610
  "/setpin": (BuildContext context) => SetPinScreen(),
};

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
        title: 'JapanThaiExpress',
        theme: ThemeData(
          //primarySwatch: Colors.grey,
          primaryColor: primaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: "/",
        routes: routes);
  }
}
