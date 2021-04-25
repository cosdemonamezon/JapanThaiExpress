import 'dart:io';
import 'package:JapanThaiExpress/Screens/Login/LoginPin.dart';
import 'package:JapanThaiExpress/Screens/Login/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:JapanThaiExpress/constants.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
String routePath = '/';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  await getDeviceDetails();
  runApp(MyApp());
}

Future<void> getDeviceDetails() async {
  String deviceName;
  String deviceVersion;
  String identifier;
  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      deviceName = build.model;
      deviceVersion = build.version.toString();
      identifier = build.androidId; //UUID for Android
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      deviceName = data.name;
      deviceVersion = data.systemVersion;
      identifier = data.identifierForVendor; //UUID for iOS
    }
  } on PlatformException {
    print('Failed to get platform version');
  }
  print(identifier);

  var url = Uri.parse(pathAPI + 'api/check_mac_mobile');
  var response = await http.post(url,
      headers: {'Content-Type': 'application/json'},
      body: convert.jsonEncode({
        'mac': identifier
        //'token': token['token']
      }));
  if (response.statusCode == 200) {
    final Map<String, dynamic> mac = convert.jsonDecode(response.body);
    if (mac['code'] == 999) {
      routePath = '/pinverify';
    }
  }

  //if (!mounted) return;
  return [deviceName, deviceVersion, identifier];
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
        initialRoute: routePath,
        routes: <String, WidgetBuilder>{
          '/': (context) => LoginScreen(),
          '/pinverify': (context) => LoginPin(),
        });
  }
}
