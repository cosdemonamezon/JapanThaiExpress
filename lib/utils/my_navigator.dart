import 'package:JapanThaiExpress/AdminScreens/Auction/TimeLineAuctions.dart';
import 'package:JapanThaiExpress/AdminScreens/Depository/TimeLineDepository.dart';
import 'package:JapanThaiExpress/AdminScreens/Message/MessageRoom.dart';
import 'package:JapanThaiExpress/AdminScreens/Customer/CustomerDetail.dart';
import 'package:JapanThaiExpress/AdminScreens/PurchaseOrders/TimeLinePurchase.dart';
import 'package:JapanThaiExpress/UserScreens/Messageuser/MessageRoom.dart';
import 'package:JapanThaiExpress/UserScreens/MyOders/TimeLinePurchaseMember.dart';
import 'package:JapanThaiExpress/UserScreens/Service/TimeLineDeposit.dart';
import 'package:JapanThaiExpress/UserScreens/Service/TimeLineMemberPreorders.dart';
import 'package:flutter/material.dart';
import 'package:JapanThaiExpress/AdminScreens/PreOders/TimeLinePreorders.dart';
import 'package:JapanThaiExpress/UserScreens/Service/TimeLineAuctionMember.dart';
import 'package:JapanThaiExpress/UserScreens/MyOders/TimeLinePreorderMember.dart';

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

  static void goToHomeScreen(BuildContext context) {
    Navigator.pushNamed(context, "/homescreen");
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

  static void goToNotiDetail(BuildContext context, arg) {
    Navigator.pushNamed(context, '/notidetail', arguments: arg);
  }

  static void goToNotiDetailUser(BuildContext context, arg) {
    Navigator.pushNamed(context, '/notidetailuser', arguments: arg);
  }

  static void goToExchangeDetail(BuildContext context, arg) {
    Navigator.pushNamed(context, '/exchangedetail', arguments: arg);
  }

  static void goTomessageuser(BuildContext context) {
    Navigator.pushNamed(context, '/messageuser');
  }

  static void goTomessagesend(BuildContext context) {
    Navigator.pushNamed(context, '/messagesend');
  }

  /*static void goToTimeLineOrderMember(BuildContext context, arg) {
    Navigator.pushNamed(context, '/timelineordermember', arguments: arg);
  }*/

static void goToTimeLineOrderMember(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimeLinePurchaseMember(),
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

  static void goToTimelinePreorder(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimeLinePreorders(),
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

  static void goToTimelinePreorderMember(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimeLinePreorderMember(),
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

  static void goToTimelinePurchase(BuildContext context, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimeLinePurchase(),
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

  static void goToTimeLineMemberPreorders(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimeLineMemberPreorders(),
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

  static void goToTimelineDeposit(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimeLineDeposit(),
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
        builder: (context) => TimeLineDepository(),
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
          arguments: {"id": id.toString()},
        ),
      ),
    );
    // Navigator.pushNamed(context, '/timelineorders', arguments: arg);
  }

  static void goToMessageRoomUser(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageRoomUser(),
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

  static void goToTimelineauction(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimelineAuctions(),
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

  static void goToCustomerDetail(
      BuildContext context, List customers, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerDetail(),
        // Pass the arguments as part of the RouteSettings. The
        // ExtractArgumentScreen reads the arguments from these
        // settings.
        settings: RouteSettings(
          arguments: {
            "id": customers[index]['id'].toString(),
            "profile": customers[index]['profile'].toString(),
            "fname_th": customers[index]['fname_th'].toString(),
            "lname_th": customers[index]['lname_th'].toString(),
            "fname_en": customers[index]['fname_en'].toString(),
            "lname_en": customers[index]['lname_en'].toString(),
            "email": customers[index]['email'].toString(),
            "phone": customers[index]['tel'].toString()
          },
        ),
      ),
    );
    // Navigator.pushNamed(context, '/timelineorders', arguments: arg);
  }

  static void goToTimelineauctionMember(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimelineAuctionMember(),
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
}
