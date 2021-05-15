import 'dart:io';

import 'package:JapanThaiExpress/AdminScreens/Settings/SettingScreen.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class ProfileAdmin extends StatefulWidget {
  ProfileAdmin({Key key}) : super(key: key);

  @override
  _ProfileAdminState createState() => _ProfileAdminState();
}

class _ProfileAdminState extends State<ProfileAdmin> {
  SharedPreferences prefs;
  String deviceName;
  String deviceVersion;
  String identifier;
  String profile;

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
        MyNavigator.goToLogin(context);
      } else {
        print(bodydata['code']);
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ตั้งค่า"),
        leading: IconButton(
            onPressed: () {
              MyNavigator.goToAdmin(context);
              // MaterialPageRoute(builder: (context) => SettingScreen());
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            )),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: FlatButton(
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: Color(0xFFF5F6F9),
                onPressed: () {
                  // print('click');
                  // MaterialPageRoute(builder: (context) => SettingScreen());
                  MyNavigator.goToSettingAdmin(context);
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/Settings.svg',
                      color: kPrimaryColor,
                      width: 22,
                    ),
                    SizedBox(width: 20),
                    Expanded(child: Text('ตั่งค่าข้อมูล')),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: FlatButton(
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: Color(0xFFF5F6F9),
                onPressed: () {
                  _logOut();
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/Log out.svg',
                      color: kPrimaryColor,
                      width: 22,
                    ),
                    SizedBox(width: 20),
                    Expanded(child: Text('ออกจากระบบ')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
