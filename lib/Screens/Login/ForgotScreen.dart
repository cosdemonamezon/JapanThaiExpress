import 'package:JapanThaiExpress/Screens/Login/LoginPin.dart';
import 'package:JapanThaiExpress/Screens/Login/LoginScreen.dart';
import 'package:JapanThaiExpress/Screens/Register/RegisterScreen.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class ForgotScreen extends StatefulWidget {
  ForgotScreen({Key key}) : super(key: key);

  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  String otp_ref = '';

  _forgotPassword(Map<String, dynamic> values) async {
    print(values);
    var url = Uri.parse(pathAPI + 'api/sendOTPForgot');
    var response = await http.post(url,
        headers: {
          //'Content-Type': 'application/json',
          //'Authorization': token['data']['token']
        },
        body: ({
          'tel': values['tel'],
        }));
    if (response.statusCode == 200) {
      final Map<String, dynamic> res = convert.jsonDecode(response.body);
        setState(() {
        otp_ref = res['data']['otp_ref'];
      });
      var arg = {
        'tel': _formKey.currentState.fields['tel'].value,
        'otp_ref': otp_ref,
      };
      MyNavigator.goToOtpforgotScreen(context, arg);
    } else {
      print("error");
      //var feedback = convert.jsonDecode(response.body);
      //print("${feedback['message']}");
      Flushbar(
        title: 'ข้อผิดพลาดจากระบบ',
        message: 'รหัสข้อผิดพลาด : 500',
        backgroundColor: Colors.redAccent,
        icon: Icon(
          Icons.error,
          size: 28.0,
          color: Colors.white,
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.blue[300],
      )..show(context);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("ลืมรหัสผ่าน"),
      ),
      body: Container(
        height: height,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: height * .10),
                Hero(
                  tag: "hero",
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: AssetImage("assets/logo.png"),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                FormBuilder(
                  key: _formKey,
                  initialValue: {
                    'tel': '',
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "เบอร์โทรศัพท์",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        FormBuilderTextField(
                            name: 'tel',
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone),
                                labelText: 'เบอร์โทรศัพท์',
                                //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true),
                            keyboardType: TextInputType.phone,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: 'กรุณากรอกเบอร์โทรศัพท์'),
                              
                            ])),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState.saveAndValidate()) {
                              setState(() {
                                isLoading = true;
                              });
                              _forgotPassword(_formKey.currentState.value);

                              // Navigator.push(context,
                              //     MaterialPageRoute(builder: (context) => LoginScreen()));
                              // showDialog(
                              //   barrierDismissible: true,
                              //   context: context,
                              //   builder: (context) => alertForgot(
                              //     "ระบบได้ส่งรหัส ไปที่ อีเมลที่ท่านได้กรอกไว้แล้ว",
                              //     picWanning,
                              //     context,
                              //   ),
                              // );
                            } else {}
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
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
                                  colors: [
                                    Color(0xffdd4b39),
                                    Color(0xffdd4b39)
                                  ]),
                            ),
                            child: isLoading == true
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Text(
                                    "ยืนยัน",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // _divider(),
                //_facebookButton(),
                // SizedBox(height: height * .045),
                //_createAccountLabel(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  _facebookButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff1959a9),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('f',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff2872ba),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('Log in with Facebook',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RegisterScreen()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already account ?',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Go to Sign In',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  alertForgot(String title, String img, context) {
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
                      color: Colors.black,
                      offset: Offset(0, 10),
                      blurRadius: 10),
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
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
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
                      Navigator.pop(context);
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
}
