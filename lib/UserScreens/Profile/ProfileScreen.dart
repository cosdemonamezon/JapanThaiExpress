import 'dart:io';
import 'package:JapanThaiExpress/UserScreens/Profile/components/Myaccount.dart';
import 'package:JapanThaiExpress/UserScreens/Profile/components/Bank.dart';
import 'package:JapanThaiExpress/UserScreens/Profile/components/body.dart';
import 'package:JapanThaiExpress/UserScreens/Profile/components/contactus.dart';
import 'package:JapanThaiExpress/UserScreens/Profile/components/editpassword.dart';
import 'package:JapanThaiExpress/UserScreens/Profile/components/privacy.dart';
import 'package:JapanThaiExpress/UserScreens/Profile/components/profile_menu.dart';
import 'package:JapanThaiExpress/UserScreens/Profile/components/profile_pic.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/Contact.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  SharedPreferences prefs;
  String deviceName;
  String deviceVersion;
  String identifier;
  String profile;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

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
        var feedback = convert.jsonDecode(response.body);
        Flushbar(
          title: '${feedback['message']}',
          message: 'รหัสข้อผิดพลาด : ${feedback['code']}',
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
        message: 'รหัสข้อผิดพลาด : ${feedback['code']}',
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
  }

  _loadData() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var url = Uri.parse(pathAPI + 'api/get_member');
    var response = await http.get(
      url,
      headers: {
        //'Content-Type': 'application/json',
        'Authorization': token['data']['token']
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = convert.jsonDecode(response.body);
      setState(() {
        profile = data['data']['profile'];
      });
    } else {
      var feedback = convert.jsonDecode(response.body);
      Flushbar(
        title: '${feedback['message']}',
        message: 'รหัสข้อผิดพลาด : ${feedback['code']}',
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("โปรไฟล์"),
        leading: IconButton(
            onPressed: () {
              MyNavigator.goBackUserHome(context);
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
            SizedBox(
              height: 150,
              width: 150,
              child: Stack(
                fit: StackFit.expand,
                overflow: Overflow.visible,
                children: [
                  CircleAvatar(
                    backgroundImage: profile == null
                        ? NetworkImage('https://via.placeholder.com/150')
                        : NetworkImage(profile),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ProfileMenu(
              text: "แก้ไขโปรไฟล์",
              icon: Icon(Icons.account_circle_outlined),
              press: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Myaccount()));
              },
            ),
            ProfileMenu(
              text: "แก้ไขรหัสผ่าน",
              icon: Icon(Icons.lock_outline_rounded),
              press: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Editpassword()));
              },
            ),
            ProfileMenu(
              text: "นโยบายความเป็นส่วนตัว",
              icon: Icon(Icons.visibility_outlined),
              press: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PrivacyPolicy()));
              },
            ),
            ProfileMenu(
              text: "ช่องทางการติดต่อ",
              icon: Icon(Icons.phone_in_talk_outlined),
              press: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ContactUs()));
              },
            ),
            // ProfileMenu(
            //   text: "จัดการที่อยู่",
            //   icon: "assets/icons/User Icon.svg",
            //   press: () {
            //     // Navigator.push(context,
            //     //     MaterialPageRoute(builder: (context) => Myaccount()));
            //   },
            // ),
            // ProfileMenu(
            //   text: "จัดการบัญชี",
            //   icon: "assets/icons/coins.svg",
            //   press: () {
            //     Navigator.push(
            //         context, MaterialPageRoute(builder: (context) => Bank()));
            //   },
            // ),
            // ProfileMenu(
            //   text: "Settings",
            //   icon: "assets/icons/Settings.svg",
            //   press: () {},
            // ),
            ProfileMenu(
              text: "ศูนย์ช่วยเหลือ",
              icon: Icon(Icons.help_outline),
              press: () {
                MyNavigator.goToHelp(context);
              },
            ),
            ProfileMenu(
              text: "ออกจากระบบ",
              icon: Icon(Icons.login_outlined),
              press: () {
                _logOut();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(),
    );
  }
}
