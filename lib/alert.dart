import 'package:JapanThaiExpress/UserScreens/Service/Service.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

String touchID = "Touch ID for C.A.BRIVE CORREZE";
String subTouchID = "Use your Touch ID for faster, eaier";
String secoundTouchID = "Access to your account";
String faceID = "Use your Face ID for faster, eaier";
String picSuccess = "assets/success.png";
String picDenied = "assets/denied.png";

// class Constants {
//   Constants._();
//   static const double padding = 20;
//   static const double avatarRadius = 45;
// }

alertdialog(
    String title, String subtitle, String secoundtitle, String img, context) {
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
              color: kFontPrimaryColor,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Image.asset(
                  img,
                  fit: BoxFit.cover,
                  height: 60,
                  width: 60,
                  //color: kButtonColor,
                ),
              ),
              SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kInputSearchColor),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 15, color: kInputSearchColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                secoundtitle,
                style: TextStyle(fontSize: 15, color: kInputSearchColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 33,
              ),
              Container(
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: kPrimaryColor,
                ),
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Service()));
                  },
                  child: Text(
                    "ตกลง",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kTextButtonColor),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                //height: size.height * 0.08,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: kPrimaryColor,
                ),
                child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("CANCEL",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kButtonColor)),
                ),
              ),
<<<<<<< HEAD
=======
              // Container(
              //   //height: size.height * 0.08,
              //   width: 200,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(16),
              //     color: kPrimaryColor,
              //   ),
              //   child: FlatButton(
              //     onPressed: () {
              //       Navigator.pop(context);
              //     },
              //     child: Text("ยกเลิก",
              //         style: TextStyle(
              //             fontSize: 16,
              //             fontWeight: FontWeight.bold,
              //             color: kTextButtonColor)),
              //   ),
              // ),
>>>>>>> 3e7fad007335d96df751ea867e8e6b1310826883
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

errordialog(String title, String subtitle, String img, context){
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
            bottom: Constants.padding
          ),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: kFontPrimaryColor,
            borderRadius: BorderRadius.circular(Constants.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black, offset: Offset(0, 10), blurRadius: 10
              ),
            ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Image.asset(
                  img,
                  fit: BoxFit.cover,
                  height: 60,
                  width: 60,
                  //color: kButtonColor,
                ),
              ),
              SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kInputSearchColor),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 15, color: kInputSearchColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 33,
              ),
              Container(
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: kPrimaryColor,
                ),
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Service()));
                  },
                  child: Text(
                    "ตกลง",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kTextButtonColor),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

alertDeposit(String title, String img, context) {
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
            bottom: Constants.padding
          ),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: kFontPrimaryColor,
            borderRadius: BorderRadius.circular(Constants.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black, offset: Offset(0, 10), blurRadius: 10
              ),
            ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Image.asset(
                  img,
                  fit: BoxFit.cover,
                  height: 60,
                  width: 60,
                  //color: kButtonColor,
                ),
              ),
              SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kInputSearchColor),
              ),
              SizedBox(
                height: 15,
              ),              
              SizedBox(
                height: 33,
              ),
              Container(
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: kPrimaryColor,
                ),
                child: FlatButton(
                  onPressed: () {
                    MyNavigator.goToDeposit(context);
                  },
                  child: Text(
                    "ตกลง",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kTextButtonColor),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
