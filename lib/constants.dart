import 'package:flutter/material.dart';
import 'package:JapanThaiExpress/size_config.dart';

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

String pathAPI = "http://103.74.253.96/japanthaiexpress-api/public/";

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

