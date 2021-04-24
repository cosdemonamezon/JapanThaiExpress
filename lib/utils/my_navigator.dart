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

  static void goToSetPin(BuildContext context) {
    Navigator.pushNamed(context, '/setpin');
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

  static void goToNews(BuildContext context) {
    Navigator.pushNamed(context, "/news");
  }

  static void goToNewsDetial(BuildContext context, arg) {
    Navigator.pushNamed(context, '/newsdetail', arguments: arg);
  }

  static void goToService(BuildContext context) {
    Navigator.pushNamed(context, "/service");
  }  

  static void goToReceiveMoney(BuildContext context) {
    Navigator.pushNamed(context, "/receivemoney");
  }

  static void goToProfileScreen(BuildContext context) {
    Navigator.pushNamed(context, "/profile");
  }

  static void goBackUserHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, "/goback", (route) => false);
  }

  static void goToAuction(BuildContext context) {
    Navigator.pushNamed(context, '/auction');
  }

  static void goToMyaccount(BuildContext context) {
    Navigator.pushNamed(context, '/myaccount');
  }
  static void goToTest(BuildContext context) {
    Navigator.pushNamed(context, '/testregis');
  }
}
