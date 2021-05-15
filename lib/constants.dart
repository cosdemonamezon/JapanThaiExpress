import 'package:flutter/material.dart';
import 'package:JapanThaiExpress/size_config.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'dart:async';
import 'package:http/http.dart' as http;

import 'AdminScreens/PreOders/TimeLinePreorders.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';

const primaryColor = Color(0xffdd4b39);
const kTextColor = Color(0xFF535353);
const kTextLightColor = Color(0xff1c1c1c);
const kButtonColor = Color(0xffe3d6b3);
const kFontPrimaryColor = Color(0xffffffff);
const kFontTextColor = Color(0xffaaaaaa);
const kTextButtonColor = Color(0xff1c1c1c);
const kInputSearchColor = Color(0xff333333);
const kFontSecondTextColor = Color(0xff888888);
const kCicleColor = Color(0xffd6c28d);

const kDefaultPaddin = 20.0;
const kPrimaryColor = Color(0xFFFF7643);
const kSecondaryColor = Color(0xFF979797);
const kBackgroundColor = Color(0xFF979797);

// String pathAPI = "http://103.74.253.96/japanthaiexpress-api/public/";
String pathAPI =
    "https://japan.logo-design360.com/japanthaiexpress-api-master/public/";

const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

String picSuccess = "assets/success.png";
String picDenied = "assets/denied.png";
String picWanning = "assets/wanning.png";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: OutlineInputBorder(),
  focusedBorder: OutlineInputBorder(),
  enabledBorder: OutlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

dialogDenied(String title, String img, context) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Constants.padding),
    ),
    elevation: 20,
    backgroundColor: Colors.transparent,
    child: Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/loginScreen',
                        (Route<dynamic> route) => false);
                  },
                  padding: EdgeInsets.all(12),
                  color: Color(0xFF01579B),
                  child: Text('ตกลง',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child: Image.asset(img)),
          ),
        ),
      ],
    ),
  );
}

errordialog(String title, String subtitle, String img, context) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Constants.padding),
    ),
    elevation: 4,
    backgroundColor: Colors.transparent,
    child: Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.all(12),
                  color: Color(0xFF01579B),
                  child: Text('ตกลง',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child: Image.asset(img)),
          ),
        ),
      ],
    ),
  );
}

successdialog(String title, String img, context) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Constants.padding),
    ),
    elevation: 4,
    backgroundColor: Colors.transparent,
    child: Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (Route<dynamic> route) => false);
                  },
                  padding: EdgeInsets.all(12),
                  color: Color(0xFF01579B),
                  child: Text('ตกลง',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child: Image.asset(img)),
          ),
        ),
      ],
    ),
  );
}

dialogHome(String title, String img, context) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Constants.padding),
    ),
    elevation: 20,
    backgroundColor: Colors.transparent,
    child: Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (Route<dynamic> route) => false);
                  },
                  padding: EdgeInsets.all(12),
                  color: Color(0xFF01579B),
                  child: Text('ตกลง',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child: Image.asset(img)),
          ),
        ),
      ],
    ),
  );
}

dialogConfrim(
  String title,
  String img,
  context,
) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Constants.padding),
    ),
    elevation: 4,
    backgroundColor: Colors.transparent,
    child: Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 22,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.all(12),
                      color: Color(0xFFD50000),
                      child: Text('ยกเลิก',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/home', (Route<dynamic> route) => false);
                      },
                      padding: EdgeInsets.all(12),
                      color: Color(0xFF01579B),
                      child: Text('ตกลง',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child: Image.asset(img)),
          ),
        ),
      ],
    ),
  );
}

errorPopup(String title, String img, context) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Constants.padding),
    ),
    elevation: 20,
    backgroundColor: Colors.transparent,
    child: Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.all(12),
                  color: Color(0xFF01579B),
                  child: Text('ตกลง',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child: Image.asset(img)),
          ),
        ),
      ],
    ),
  );
}

dialogAlert(String title, String img, context) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Constants.padding),
    ),
    elevation: 4,
    backgroundColor: Colors.transparent,
    child: Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.all(12),
                  color: Colors.red,
                  child: Text('ปิด',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child: Image.asset(img)),
          ),
        ),
      ],
    ),
  );
}
