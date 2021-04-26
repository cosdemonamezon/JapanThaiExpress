import 'dart:io';

import 'package:JapanThaiExpress/UserScreens/Profile/components/Bank.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:device_info/device_info.dart';
import 'package:JapanThaiExpress/UserScreens/Profile/components/Myaccount.dart';
import 'package:flutter/material.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatelessWidget {
  SharedPreferences prefs;
  String deviceName;
  String deviceVersion;
  String identifier;

  _logOut() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
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

    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var url = Uri.parse(pathAPI + 'api/app/logout');
    var response = await http.post(url,
        headers: {
          //'Content-Type': 'application/json',
          'Authorization': token['data']['token']
        },
        body: ({
          'device': identifier,
        }));
    if (response.statusCode == 200) {
      final Map<String, dynamic> bodydata = convert.jsonDecode(response.body);
      if (bodydata['code'] == 200) {
        //MyNavigator.goToService(context);

      } else {
        print(bodydata['code']);
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/User Icon.svg",
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Myaccount()));
            },
          ),
          ProfileMenu(
            text: "จัดการบัญชี",
            icon: "assets/icons/coins.svg",
            press: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Bank()));
            },
          ),
          // ProfileMenu(
          //   text: "Settings",
          //   icon: "assets/icons/Settings.svg",
          //   press: () {},
          // ),
          ProfileMenu(
            text: "Help Center",
            icon: "assets/icons/Question mark.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () {},
          ),
        ],
      ),
    );
  }
}
