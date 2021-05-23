import 'package:JapanThaiExpress/AdminScreens/Home/HomeScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/Message/MessageScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/Notification/NotificationScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/Settings/ProfileAdmin.dart';
import 'package:JapanThaiExpress/AdminScreens/Settings/SettingScreen.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:another_flushbar/flushbar.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  Navigation({Key key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  bool nbtn1 = false;
  bool nbtn2 = false;
  bool nbtn3 = false;
  bool nbtn4 = false;
  bool isLoading = false;
  SharedPreferences prefs;
  Map<String, dynamic> homedata = {};
  String noti;
  String msg;

  @override
  void initState() {
    super.initState();
    _getHome();
  }

  _getHome() async {
    try {
      prefs = await SharedPreferences.getInstance();
      var tokenString = prefs.getString('token');
      var token = convert.jsonDecode(tokenString);
      var url = Uri.parse(pathAPI + 'api/get_home_app');
      var response = await http.get(
        url,
        headers: {
          //'Content-Type': 'application/json',
          'Authorization': token['data']['token']
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> homebody = convert.jsonDecode(response.body);
        if (homebody['code'] == 200) {
          setState(() {
            homedata = homebody['data'];
            noti = homedata['total_noti'].toString();
            msg = homedata['total_msg'].toString();
            isLoading = false;
          });
          print(homedata);
          print(noti.length);
          print(msg.length);
          // Flushbar(
          //   //title: '${feedback['message']}',
          //   flushbarPosition: FlushbarPosition.TOP,
          //   flushbarStyle: FlushbarStyle.FLOATING,
          //   message: '${homebody['message']}',
          //   backgroundColor: Colors.greenAccent,
          //   icon: Icon(
          //     Icons.error,
          //     size: 28.0,
          //     color: Colors.white,
          //   ),
          //   duration: Duration(seconds: 3),
          //   leftBarIndicatorColor: Colors.blue[300],
          // )..show(context);
        } else {
          Flushbar(
            title: '${homebody['message']}',
            message: 'รหัสข้อผิดพลาด : ${homebody['code']}',
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
        setState(() {
          isLoading = false;
        });
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
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffdd4b39),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xffdd4b39),
                    //backgroundImage: AssetImage(pathicon1),
                    radius: 24,
                    child: IconButton(
                        iconSize: 30,
                        color: Colors.white,
                        icon: Icon(Icons.home),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        }),
                  ),
                  Text(
                    "หน้าหลัก",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0xffdd4b39),
                          //backgroundImage: AssetImage(pathicon1),
                          radius: 24,
                          child: IconButton(
                              iconSize: 30,
                              color: Colors.white,
                              icon: Icon(Icons.notifications),
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NotificationScreen()));
                              }),
                        ),
                        Text(
                          "แจ้งเตือน",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 10,
                    //left: 0,
                    top: 0,
                    //bottom: 0,
                    child: homedata['total_noti'] != 0
                        ? CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                            child: Center(
                              child: homedata['total_noti'] != null &&
                                      noti.length == 2
                                  ? Text(homedata['total_noti'].toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.white,
                                      ))
                                  : homedata['total_noti'] != null &&
                                          noti.length == 3
                                      ? Text(homedata['total_noti'].toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                            color: Colors.white,
                                          ))
                                      : Text("0",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white,
                                          )),
                            ),
                          )
                        : SizedBox(
                            height: 2,
                          ),
                  ),
                ],
              ),
              ////

              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0xffdd4b39),
                          //backgroundImage: AssetImage(pathicon1),
                          radius: 24,
                          child: IconButton(
                              iconSize: 30,
                              color: Colors.white,
                              icon: Icon(Icons.chat_bubble),
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MessageScreen()));
                              }),
                        ),
                        Text(
                          "ข้อความ",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 5,
                    //left: 0,
                    top: 0,
                    //bottom: 0,
<<<<<<< HEAD
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.red,
                      child: Center(
                        child: homedata['total_msg'] != null && noti.length == 2
                          ? Text(homedata['total_msg'].toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white,
                              ))
                          : homedata['total_msg'] != null && noti.length == 3
                              ? Text(homedata['total_msg'].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: Colors.white,
                                  ))
                              : Text("0",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white,
                                  )),
                      ),
                    ),
=======
                    child: homedata['total_msg'] != 0
                        ? CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                            child: Center(
                              child: homedata['total_msg'] != null &&
                                      noti.length == 2
                                  ? Text(homedata['total_msg'].toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.white,
                                      ))
                                  : homedata['total_msg'] != null &&
                                          noti.length == 3
                                      ? Text(homedata['total_msg'].toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                            color: Colors.white,
                                          ))
                                      : Text("0",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white,
                                          )),
                            ),
                          )
                        : SizedBox(
                            height: 2,
                          ),
>>>>>>> 7162743edf949f3a6ae0eb6eeaaa38801c15fe7b
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xffdd4b39),
                      //backgroundImage: AssetImage(pathicon1),
                      radius: 24,
                      child: IconButton(
                          iconSize: 30,
                          color: Colors.white,
                          icon: Icon(Icons.settings),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                // MaterialPageRoute(
                                //     builder: (context) => SettingScreen()));
                                MaterialPageRoute(
                                    builder: (context) => ProfileAdmin()));
                          }),
                    ),
                    Text(
                      "ตั้งค่า",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
