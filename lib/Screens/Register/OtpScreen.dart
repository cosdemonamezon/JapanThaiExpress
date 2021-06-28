import 'dart:async';

import 'package:JapanThaiExpress/Screens/Register/SetPin.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/size_config.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:JapanThaiExpress/constants.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({Key key}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  SharedPreferences prefs;
  Map<String, dynamic> _data;
  bool isLoading = false;
  FocusNode pin2FocusNode;
  FocusNode pin3FocusNode;
  FocusNode pin4FocusNode;
  FocusNode pin5FocusNode;
  FocusNode pin6FocusNode;
  bool hasError = false;
  String currentText = "";
  TextEditingController textEditingController = TextEditingController();
  String tokendata = "";
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    setState(() {
      _data = data;
    });
    print(_data);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("ยืนยัน OTP"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              "ยืนยัน OTP Ref. " + _data['otp_ref'],
              style: TextStyle(color: kPrimaryColor),
            ),
          ),
          Center(child: Text("รหัสยืนยันได้ส่งไปที่เบอร์โทร " + data['tel'])),
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
                  if (v.length < 5) {
                    return "กรุณากรอกรหัสยืนยัน";
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
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.shade200,
                      offset: Offset(2, 4),
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xffdd4b39), Color(0xffdd4b39)]),
              ),
              child: isLoading == true
                  ? Center(child: CircularProgressIndicator())
                  : GestureDetector(
                      onTap: () {
                        _checkOtp(data['tel'], data['otp_ref'], currentText);
                      },
                      child: Text(
                        "ยืนยัน",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("รหัสผ่านจะหมดอายุใน "),
        TweenAnimationBuilder<Duration>(
            duration: Duration(minutes: 10),
            tween: Tween(begin: Duration(minutes: 10), end: Duration.zero),
            onEnd: () {
              MyNavigator.goToLogin(context);
            },
            builder: (BuildContext context, Duration value, Widget child) {
              final minutes = value.inMinutes;
              final seconds = value.inSeconds % 60;
              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text('$minutes:$seconds',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      )));
            }),
        // TweenAnimationBuilder(
        //   onEnd: () {
        //     MyNavigator.goToLogin(context);
        //   },
        //   tween: Tween(begin: 600.0, end: 0.0),
        //   duration: Duration(seconds: 600),
        //   builder: (_, value, child) => Text(
        //     "00:${value.toInt()}",
        //     style: TextStyle(color: kPrimaryColor),
        //   ),
        // ),
      ],
    );
  }

  _checkOtp(String tel, String ref, String code) async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(pathAPI + 'api/checkOTP');
    var response = await http.post(
      url,
      headers: {},
      body: ({
        'tel': tel,
        'otp_ref': ref,
        'otp_code': code,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      final Map<String, dynamic> res = convert.jsonDecode(response.body);
      print(res);
      _register(_data);
    } else {
      setState(() {
        isLoading = false;
      });
      final Map<String, dynamic> res = convert.jsonDecode(response.body);
      print(res);
    }
  }

  _register(Map<dynamic, dynamic> data) async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(pathAPI + 'api/register');
    var response = await http.post(
      url,
      headers: {},
      body: ({
        'fname_th': data['fname_th'].toString(),
        'lname_th': data['lname_th'].toString(),
        'fname_en': data['fname_en'].toString(),
        'lname_en': data['lname_en'].toString(),
        'email': data['email'].toString(),
        'tel': data['tel'].toString(),
        'password': data['password'].toString(),
      }),
    );
    if (response.statusCode == 201) {
      setState(() {
        isLoading = false;
      });
      final Map<String, dynamic> res = convert.jsonDecode(response.body);
      await prefs.setString('token', response.body);
      MyNavigator.goToSetPin(context);
    } else {
      setState(() {
        isLoading = false;
      });
      final Map<String, dynamic> res = convert.jsonDecode(response.body);
      print(res);
    }
  }
}
