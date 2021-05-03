import 'package:JapanThaiExpress/AdminScreens/Home/HomeScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/Message/MessageScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/Notification/NotificationScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/Settings/ProfileAdmin.dart';
import 'package:JapanThaiExpress/AdminScreens/Settings/SettingScreen.dart';

import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  Navigation({Key key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
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
