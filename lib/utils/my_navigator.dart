import 'package:flutter/material.dart';

class MyNavigator {
  static void goToMain(BuildContext context) {
    Navigator.pushNamed(context, "/");
  }

  static void goToIntro(BuildContext context) {
    Navigator.pushNamed(context, "/intro");
  }

  static void goToHome(BuildContext context) {
    Navigator.pushNamed(context, "/home");
  }

  static void goToLogin(BuildContext context) {
    Navigator.pushNamed(context, "/login");
  }

  static void goToLoginByPin(BuildContext context) {
    Navigator.pushNamed(context, '/pinverify');
  }
  static void goToDeposit(BuildContext context) {
    Navigator.pushNamed(context, '/deposit');
  }

  static void goToDepositDetail(BuildContext context, arg) {
    Navigator.pushNamed(context, '/depositdetail', arguments: arg);
  }

  static void goToQRCodePreview(BuildContext context, arg) {
    Navigator.pushNamed(context, '/qrcodepreview', arguments: arg);
  }

  static void goToTimelineOrders(BuildContext context) {
    Navigator.pushNamed(context, '/timelineorders');
  }
  // static void goToLoginByPin(BuildContext context, arg) {
  //   Navigator.pushNamed(context, '/pinverify', arguments: arg);
  // }

  static void goToAdmin(BuildContext context) {
    Navigator.pushNamed(context, "/adminhome");
  }

  static void goToMember(BuildContext context) {
    Navigator.pushNamed(context, "/memberhome");
  }

  static void goToUser(BuildContext context) {
    Navigator.pushNamed(context, "/user");
  }

  static void goToForgot(BuildContext context) {
    Navigator.pushNamed(context, "/forgot");
  }

  static void goToRegister(BuildContext context) {
    Navigator.pushNamed(context, "/register");
  }
}
