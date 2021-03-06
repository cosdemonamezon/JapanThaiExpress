import 'dart:io';

import 'package:JapanThaiExpress/AdminScreens/Home/HomeScreen.dart';
import 'package:JapanThaiExpress/Screens/Login/NumberpadSetPin.dart';
import 'package:JapanThaiExpress/UserScreens/Dashboard/DashbordScreen.dart';
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:JapanThaiExpress/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:JapanThaiExpress/alert.dart';
import 'package:JapanThaiExpress/utils/japanexpress.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:another_flushbar/flushbar.dart';

import '../../utils/my_navigator.dart';
import 'Numberpad.dart';

class SetPinScreen extends StatefulWidget {
  SetPinScreen({Key key}) : super(key: key);

  @override
  _SetPinState createState() => _SetPinState();
}

class _SetPinState extends State<SetPinScreen> {
  int length = 6;
  onChange(String number) {
    _handleSubmitted(number);
  }

  String deviceName;
  String deviceVersion;
  String identifier;

  SharedPreferences prefs;
  _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _handleSubmitted(String number) async {
    if (number.length == length) {
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

        var tokenString = prefs.getString('token');
        final Map<String, dynamic> body = convert.jsonDecode(tokenString);

        var url = Uri.parse(pathAPI + 'api/set_pin');
        var response = await http.post(url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': body['data']['token'],
            },
            body: convert.jsonEncode({
              'pin': number,
            }));

        if (response.statusCode == 200) {
          final Map<String, dynamic> body = convert.jsonDecode(response.body);
          if (body['code'] == 200 || body['code'] == 999) {
            if (body['data']['type'] == "admin")
              MyNavigator.goToAdmin(context);
            else
              MyNavigator.goToMember(context);
            return false;
          } else {
            var feedback = convert.jsonDecode(response.body);
            print(feedback);
            Flushbar(
              title: '${feedback['message']}',
              message: 'เกิดข้อผิดพลาดจากระบบ : ${feedback['code']}',
              backgroundColor: Colors.redAccent,
              icon: Icon(
                Icons.error,
                size: 28.0,
                color: Colors.white,
              ),
              duration: Duration(seconds: 3),
              leftBarIndicatorColor: Colors.blue[300],
            )..show(context);
          }
        } else {
          var feedback = convert.jsonDecode(response.body);
          Flushbar(
            title: '${feedback['message']}',
            message: 'เกิดข้อผิดพลาดจากระบบ : ${feedback['code']}',
            backgroundColor: Colors.redAccent,
            icon: Icon(
              Icons.error,
              size: 28.0,
              color: Colors.white,
            ),
            duration: Duration(seconds: 3),
            leftBarIndicatorColor: Colors.blue[300],
          )..show(context);
        }
      } on PlatformException {
        print('Failed to get platform version');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;

    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Login Pin"),
      // ),
      body: Container(
        height: height,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: height * .10),
                Hero(
                  tag: "hero",
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 85,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: AssetImage("assets/logo.png"),
                        
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('กรุณาตั้งค่า PIN',style: TextStyle(fontSize: 20),),
                SizedBox(height: 10),
                Numberpadsetpin(
                  length: length,
                  onChange: onChange,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
