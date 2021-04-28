import 'dart:async';

import 'package:JapanThaiExpress/Screens/Register/SetPin.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/size_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({Key key}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  FocusNode pin2FocusNode;
  FocusNode pin3FocusNode;
  FocusNode pin4FocusNode;
  FocusNode pin5FocusNode;
  FocusNode pin6FocusNode;
  bool hasError = false;
  String currentText = "";
  TextEditingController textEditingController = TextEditingController();
  String tokendata = "";
  SharedPreferences prefs;
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String tel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    setState(() {
      tel = data['tel'];
    });
    _sendOtp(tel);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("OTP Verification"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              "OTP Verification",
            ),
          ),
          Center(child: Text("We sent your code to " + tel)),
          Center(child: buildTimer()),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: formKey,
              child: PinCodeTextField(
                appContext: context,
                autoFocus: true,
                pastedTextStyle: TextStyle(
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.bold,
                ),
                length: 6,
                blinkWhenObscuring: true,
                animationType: AnimationType.fade,
                validator: (v) {
                  if (v.length < 3) {
                    return "I'm from validator";
                  } else {
                    return null;
                  }
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: hasError ? Colors.orange : Colors.white,
                ),
                cursorColor: Colors.black,
                animationDuration: Duration(milliseconds: 300),
                //backgroundColor: Colors.blue.shade50,
                enableActiveFill: true,
                // errorAnimationController: errorController,
                controller: textEditingController,
                keyboardType: TextInputType.number,
                boxShadows: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    color: Colors.black12,
                    blurRadius: 10,
                  )
                ],
                // onCompleted: (v) {
                //   print("Completed");
                // },
                onChanged: (value) {
                  print(value);
                  setState(() {
                    currentText = value;
                  });
                },
              ),
            ),
          ),
          SizedBox(
            height: 14,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
            child: ButtonTheme(
              height: 50,
              child: FlatButton(
                onPressed: () {
                  formKey.currentState.validate();
                  // if (currentText.length != 6) {
                  //   //errorController.add(ErrorAnimationType.shake);
                  //   print(currentText.length);
                  //   print(currentText);
                  //   print("object");
                  //   setState(() {
                  //     hasError = true;
                  //   });
                  // } else {
                  //   setState(() {
                  //     hasError = false;
                  //     scaffoldKey.currentState.showSnackBar(SnackBar(
                  //       content: Text("Aye!!"),
                  //       duration: Duration(seconds: 5),
                  //     ));
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) => SetPin()));
                  //   });
                  // }
                },
                child: Center(
                  child: Text(
                    "VERIFY".toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.green.shade300,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                      color: Colors.green.shade200,
                      offset: Offset(1, -2),
                      blurRadius: 5),
                  BoxShadow(
                      color: Colors.green.shade200,
                      offset: Offset(-1, 2),
                      blurRadius: 5)
                ]),
          ),
        ],
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("This code will expired in "),
        TweenAnimationBuilder(
          tween: Tween(begin: 60.0, end: 0.0),
          duration: Duration(seconds: 60),
          builder: (_, value, child) => Text(
            "00:${value.toInt()}",
            style: TextStyle(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }

  _sendOtp(String tel) async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var url = Uri.parse(pathAPI + 'api/sendOTP');
    var response = await http.post(url,
        headers: {
          //'Content-Type': 'application/json',
          'Authorization': token['data']['token']
        },
        body: ({
          'tel': tel.toString(),
        }));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = convert.jsonDecode(response.body);
      print(data);
    }
  }
}
