import 'dart:developer';
import 'dart:io';
import 'package:JapanThaiExpress/AdminScreens/Auction/TimeLineAuctions.dart';
import 'package:JapanThaiExpress/AdminScreens/Exchange/ExchangeDetailScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/Notification/NotiDetailScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/Settings/SettingScreen.dart';
import 'package:JapanThaiExpress/Screens/Login/SplashScreen.dart';
import 'package:JapanThaiExpress/Screens/Login/LoginPin.dart';
import 'package:JapanThaiExpress/Screens/Login/LoginScreen.dart';
import 'package:JapanThaiExpress/Screens/Login/SetPinScreen.dart';
import 'package:JapanThaiExpress/Screens/Login/intro_screen.dart';
import 'package:JapanThaiExpress/Screens/Login/home_screen.dart';
import 'package:JapanThaiExpress/Screens/Register/OtpScreen.dart';
import 'package:JapanThaiExpress/Screens/Register/RegisterScreen.dart';
import 'package:JapanThaiExpress/Screens/Login/ForgotScreen.dart';
import 'package:JapanThaiExpress/Screens/Register/Registration.dart';
import 'package:JapanThaiExpress/Screens/Register/testregis.dart';

import 'package:JapanThaiExpress/AdminScreens/Home/HomeScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/HomeServices/HomeServices.dart';
import 'package:JapanThaiExpress/AdminScreens/Deposit/DepositDetailScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/QRCodeScan/QRCodePreview.dart';
import 'package:JapanThaiExpress/AdminScreens/PreOders/TimeLinePreorders.dart';
import 'package:JapanThaiExpress/AdminScreens/PurchaseOrders/TimeLinePurchase.dart';
import 'package:JapanThaiExpress/Screens/Register/SetPin.dart';
import 'package:JapanThaiExpress/UserScreens/Dashboard/DashbordScreen.dart';
import 'package:JapanThaiExpress/UserScreens/Messageuser/Messagesend.dart';
import 'package:JapanThaiExpress/UserScreens/MyOders/OdersScreen.dart';
import 'package:JapanThaiExpress/UserScreens/News/DetailNews.dart';
import 'package:JapanThaiExpress/UserScreens/News/NewsScreen.dart';
import 'package:JapanThaiExpress/UserScreens/Products/ProductScreen.dart';
import 'package:JapanThaiExpress/UserScreens/Products/details/DetailProduct.dart';
import 'package:JapanThaiExpress/UserScreens/Products/details/OrderProduct.dart';
import 'package:JapanThaiExpress/UserScreens/Profile/ProfileScreen.dart';
import 'package:JapanThaiExpress/UserScreens/Profile/components/HelpCenter.dart';
import 'package:JapanThaiExpress/UserScreens/Profile/components/HelpDetail.dart';
import 'package:JapanThaiExpress/UserScreens/Service/Buystuff.dart';
import 'package:JapanThaiExpress/UserScreens/Service/Deposit.dart';
import 'package:JapanThaiExpress/UserScreens/Service/ReceiveDetail.dart';
import 'package:JapanThaiExpress/UserScreens/Service/ReceiveMoney.dart';
import 'package:JapanThaiExpress/UserScreens/Service/Service.dart';
import 'package:JapanThaiExpress/UserScreens/Wallet/ChooseService.dart';
import 'package:JapanThaiExpress/UserScreens/Wallet/RabbitLine.dart';
import 'package:JapanThaiExpress/UserScreens/Wallet/Topup.dart';
import 'package:JapanThaiExpress/UserScreens/Wallet/WalletScreen.dart';
import 'package:JapanThaiExpress/UserScreens/Wallet/Webview.dart';
import 'package:JapanThaiExpress/UserScreens/Profile/components/Myaccount.dart';
import 'package:JapanThaiExpress/UserScreens/Service/Auction.dart';
import 'package:JapanThaiExpress/UserScreens/Service/Deposit.dart';
import 'package:JapanThaiExpress/UserScreens/Service/ReceiveMoney.dart';
import 'package:JapanThaiExpress/UserScreens/Service/Service.dart';
import 'package:JapanThaiExpress/AdminScreens/Auction/Auctionadmin.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:JapanThaiExpress/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AdminScreens/Depository/DepositoryScreen.dart';
import 'AdminScreens/Exchange/ExchangeScreen.dart';
import 'AdminScreens/Home/HomeScreen.dart';
import 'AdminScreens/Home/HomeScreen.dart';
import 'Screens/Login/ForgotScreen.dart';
import 'Screens/Register/RegisterScreen.dart';

import 'package:JapanThaiExpress/LoginFB.dart';
import 'package:JapanThaiExpress/LoginGoogle.dart';

import 'UserScreens/Messageuser/MessageScreen.dart';
import 'UserScreens/WidgetsUser/NotiDetailUserScreen.dart';

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
  "/register": (BuildContext context) => Registration(),
  "/depositdetail": (BuildContext context) => DepositDetailScreen(),
  "/qrcodepreview": (BuildContext context) => QRCodePreview(),
  "/timelineorders": (BuildContext context) => TimeLinePreorders(),
  "/timelineorderspurchase": (BuildContext context) => TimeLinePurchase(),
  "/deposit": (BuildContext context) => Deposit(),
  "/news": (BuildContext context) => NewsScreen(),
  "/newsdetail": (BuildContext context) => DetailNews(),
  "/service": (BuildContext context) => Service(),
  "/receivemoney": (BuildContext context) => ReceiveMoney(),
  "/profile": (BuildContext context) => ProfileScreen(),
  "/goback": (BuildContext context) => DashbordScreen(),
  "/setpin": (BuildContext context) => SetPinScreen(),
  "/topup": (BuildContext context) => Topup(),
  "/help": (BuildContext context) => HelpCenter(),
  "/helpdetail": (BuildContext context) => HelpDetail(),
  "/chooseservice": (BuildContext context) => ChooseService(),
  "/rabbit": (BuildContext context) => RabbitLine(),
  "/webview": (BuildContext context) => Webview(),
  "/auction": (BuildContext context) => Auction(),
  "/myaccount": (BuildContext context) => Myaccount(),
  "/detailproduct": (BuildContext context) => DetailProduct(),
  "/orderproduct": (BuildContext context) => OrderProduct(),
  "/wallet": (BuildContext context) => WalletScreen(),
  "/product": (BuildContext context) => ProductScreen(),
  "/homeservices": (BuildContext context) => HomeServices(),
  "/myorder": (BuildContext context) => OdersScreen(),
  "/otpscreen": (BuildContext context) => OtpScreen(),
  "/receivedetail": (BuildContext context) => ReceiveDetail(),
  "/auctionadmin": (BuildContext context) => Auctionadmin(),
  "/messageuser": (BuildContext context) => MessageScreen(),
  "/settingadmin": (BuildContext context) => SettingScreen(),
  "/timelineauction": (BuildContext context) => TimelineAuctions(),
  "/messagesend": (BuildContext context) => Messagesend(),
  "/homescreen": (BuildContext context) => HomeScreen(),
  "/exchangedetail": (BuildContext context) => ExchangeDetailScreen(),
  "/buystuff": (BuildContext context) => Buystuff(),
  "/notidetail": (BuildContext context) => NotiDetailScreen(),
  "/notidetailuser": (BuildContext context) => NotiDetailUserScreen(),
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
        title: 'JapanThai Express',
        theme: ThemeData(
          fontFamily: 'Prompt',
          //primarySwatch: Colors.grey,
          primaryColor: primaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: "/",
        routes: routes);
  }
}
