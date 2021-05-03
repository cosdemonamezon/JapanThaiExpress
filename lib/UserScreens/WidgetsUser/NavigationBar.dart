import 'package:JapanThaiExpress/AdminScreens/Message/MessageScreen.dart';
import 'package:JapanThaiExpress/UserScreens/Dashboard/DashbordScreen.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/Contact.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NotificationScreen.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter/material.dart';

class NavigationBar extends StatefulWidget {
  NavigationBar({Key key}) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
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
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => HomeScreen()));
                          MyNavigator.goBackUserHome(context);
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotificationScreen()));
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
                          icon: Icon(Icons.chat_bubble),
                          onPressed: () {
                            MyNavigator.goTomessageuser(context);
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
                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => SettingScreen()));
                            MyNavigator.goToProfileScreen(context);
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