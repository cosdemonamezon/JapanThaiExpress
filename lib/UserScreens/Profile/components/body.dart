import 'package:JapanThaiExpress/UserScreens/Profile/components/Bank.dart';
import 'package:flutter/material.dart';
import 'package:JapanThaiExpress/UserScreens/Profile/Myaccount.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
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
            press: () {Navigator.push(
              context, MaterialPageRoute(builder: (context) => Myaccount()));
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
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {},
          ),
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
