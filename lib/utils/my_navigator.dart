import 'package:JapanThaiExpress/AdminScreens/Depository/TimeLineDepository.dart';
import 'package:JapanThaiExpress/AdminScreens/Message/MessageRoom.dart';
import 'package:flutter/material.dart';
import 'package:JapanThaiExpress/AdminScreens/PreOders/TimeLineScreen.dart';

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
    Navigator.pushNamedAndRemoveUntil(
        context, "/login", (Route<dynamic> route) => false);
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

  static void goTomessageuser(BuildContext context) {
    Navigator.pushNamed(context, '/messageuser');
  }
  static void goTomessagesend(BuildContext context) {
    Navigator.pushNamed(context, '/messagesend');
  }

  static void goToTimelinePreorder(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimeLineScreen(),
        // Pass the arguments as part of the RouteSettings. The
        // ExtractArgumentScreen reads the arguments from these
        // settings.
        settings: RouteSettings(
          arguments: {"id": id},
        ),
      ),
    );
    // Navigator.pushNamed(context, '/timelineorders', arguments: arg);
  }

  static void goToTimelineDepository(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimeLineDepository(),
        // Pass the arguments as part of the RouteSettings. The
        // ExtractArgumentScreen reads the arguments from these
        // settings.
        settings: RouteSettings(
          arguments: {"id": id.toString()},
        ),
      ),
    );
    // Navigator.pushNamed(context, '/timelineorders', arguments: arg);
  }

  static void goToTimelineExchange(BuildContext context, arg) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimeLineScreen(),
        // Pass the arguments as part of the RouteSettings. The
        // ExtractArgumentScreen reads the arguments from these
        // settings.
        settings: RouteSettings(
          arguments: {"id": "1"},
        ),
      ),
    );
    // Navigator.pushNamed(context, '/timelineorders', arguments: arg);
  }

  static void goToMessageRoom(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageRoom(),
        // Pass the arguments as part of the RouteSettings. The
        // ExtractArgumentScreen reads the arguments from these
        // settings.
        settings: RouteSettings(
          arguments: {"id": id},
        ),
      ),
    );
    // Navigator.pushNamed(context, '/timelineorders', arguments: arg);
  }

  static void goToTimelinepurchaseOrders(BuildContext context) {
    Navigator.pushNamed(context, '/timelineorderspurchase');
  }
  // static void goToLoginByPin(BuildContext context, arg) {
  //   Navigator.pushNamed(context, '/pinverify', arguments: arg);
  // }

  static void goToAdmin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, "/adminhome", (Route<dynamic> route) => false);
  }

  static void goToMember(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, "/memberhome", (Route<dynamic> route) => false);
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

  static void goToHelpDetail(BuildContext context, arg) {
    Navigator.pushNamed(context, '/helpdetail', arguments: arg);
  }

  static void goToWebview(BuildContext context, arg) {
    Navigator.pushNamed(context, '/webview', arguments: arg);
  }

  static void goToDetailProduct(BuildContext context, arg) {
    Navigator.pushNamed(context, '/detailproduct', arguments: arg);
  }

  static void goToOrderProduct(BuildContext context, arg) {
    Navigator.pushNamed(context, '/orderproduct', arguments: arg);
  }

  static void goToReceiveDetail(BuildContext context, arg) {
    Navigator.pushNamed(context, '/receivedetail', arguments: arg);
  }

  static void goToService(BuildContext context) {
    Navigator.pushNamed(context, "/service");
  }

  static void goToMyOrder(BuildContext context) {
    Navigator.pushNamed(context, "/myorder");
  }

  static void goToBuyStuff(BuildContext context) {
    Navigator.pushNamed(context, "/buystuff");
  }

  static void goToChooseService(BuildContext context) {
    Navigator.pushNamed(context, "/chooseservice");
  }

  static void goToLineRabbit(BuildContext context) {
    Navigator.pushNamed(context, "/rabbit");
  }

  static void goToTopup(BuildContext context) {
    Navigator.pushNamed(context, "/topup");
  }

  static void goToReceiveMoney(BuildContext context) {
    Navigator.pushNamed(context, "/receivemoney");
  }

  static void goToProfileScreen(BuildContext context) {
    Navigator.pushNamed(context, "/profile");
  }

  static void goToProductScreen(BuildContext context) {
    Navigator.pushNamed(context, "/product");
  }

  static void goToHelp(BuildContext context) {
    Navigator.pushNamed(context, "/help");
  }

  static void goToWallet(BuildContext context) {
    Navigator.pushNamed(context, "/wallet");
  }

  static void goBackUserHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, "/goback", (route) => false);
  }
  // static void goToTopup(BuildContext context) {
  //   Navigator.pushNamedAndRemoveUntil(context, "/topup", (route) => false);
  // }

  // static void goToTopup(BuildContext context) {
  //   Navigator.pushNamedAndRemoveUntil(context, "/topup", (route) => false);
  // }

  static void goToAuction(BuildContext context) {
    Navigator.pushNamed(context, '/auction');
  }

  static void goToMyaccount(BuildContext context) {
    Navigator.pushNamed(context, '/myaccount');
  }

  static void goToTest(BuildContext context) {
    Navigator.pushNamed(context, '/testregis');
  }

  static void goToHomeServices(BuildContext context) {
    Navigator.pushNamed(context, "/homeservices");
  }

  static void goToOtpScreen(BuildContext context, arg) {
    Navigator.pushNamed(context, '/otpscreen', arguments: arg);
  }

  static void goToSettingAdmin(BuildContext context) {
    Navigator.pushNamed(context, '/settingadmin');
  }

  static void goToAuctionadmin(BuildContext context) {
    Navigator.pushNamed(context, '/auctionadmin');
  }

  static void goToTimelineauction(BuildContext context) {
    Navigator.pushNamed(context, '/timelineauction');
  }
}
