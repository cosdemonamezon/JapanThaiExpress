import 'package:JapanThaiExpress/Screens/Register/OtpScreen.dart';
import 'package:JapanThaiExpress/Screens/Register/SetPin.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'dart:async';

// ignore: must_be_immutable
class Registration extends StatefulWidget {
  Registration({Key key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormBuilderState>();
  SharedPreferences prefs;
  String email;
  String tel;
  String password;
  String confirmpassword;
  String otp_ref;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("สมัครสมาชิก"),
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
                SizedBox(height: height * .01),
                FormBuilder(
                  key: _formKey,
                  initialValue: {
                    'thfname': '',
                    'thlname': '',
                    'enfname': '',
                    'enlname': '',
                    'email': '',
                    'tel': '',
                    'password': '',
                    'confirmpassword': '',
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ชื่อภาษาไทย",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        FormBuilderTextField(
                            name: 'thfname',
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: 'ชื่อ(ภาษาไทย)',
                                //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: 'กรุณากรอกชื่อภาษาไทย'),
                            ])),
                        SizedBox(height: 10),
                        Text(
                          "นามสกุลภาษาไทย",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        FormBuilderTextField(
                            name: 'thlname',
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: 'นามสกุล(ภาษาไทย)',
                                //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: 'กรุณากรอกนามสกุลภาษาไทย'),
                            ])),
                        SizedBox(height: 10),
                         Text(
                          "ชื่อภาษาอังกฤษ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        FormBuilderTextField(
                            name: 'enfname',
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: 'ชื่อ(ภาษาอังกฤษ)',
                                //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: 'กรุณากรอกชื่อภาษาอังกฤษ'),
                            ])),
                        SizedBox(height: 10),
                        Text(
                          "นามสกุลภาษาอังกฤษ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        FormBuilderTextField(
                            name: 'enlname',
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: 'นามสกุล(ภาษาอังกฤษ)',
                                //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: 'กรุณากรอกนามสกุลภาษาอังกฤษ'),
                            ])),
                        SizedBox(height: 10),
                        Text(
                          "อีเมล์",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        FormBuilderTextField(
                            name: 'email',
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                labelText: 'อีเมล',
                                //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: 'กรุณากรอกอีเมล'),
                              FormBuilderValidators.email(context,
                                  errorText: 'กรุณากรอกอีเมลให้ถูกต้อง'),
                            ])),
                        SizedBox(height: 10),
                        Text(
                          "เบอร์โทรศัพท์",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        FormBuilderTextField(
                            name: 'tel',
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone),
                                labelText: 'หมายเลขโทรศัพท์',
                                //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: 'กรุณากรอกหมายเลขโทรศัพท์'),
                              FormBuilderValidators.minLength(context, 10,
                                  errorText:
                                      'กรุณากรอกหมา่ยเลขโทรศัพท์ให้ครบถ้วน'),
                            ])),
                        SizedBox(height: 10),
                        Text(
                          "รหัสผ่าน",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        FormBuilderTextField(
                            name: 'password',
                            obscureText: true,
                            obscuringCharacter: "•",
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                labelText: 'รหัสผ่าน',
                                //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true),
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: 'กรุณากรอกรหัสผ่าน'),
                              FormBuilderValidators.minLength(context, 8,
                                  errorText: 'กรุณากรอกรหัสอย่างน้อย 8 ตัว')
                            ])),
                        SizedBox(height: 10),
                        Text(
                          "ยืนยันรหัสผ่าน",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        FormBuilderTextField(
                            name: 'confirmpassword',
                            obscureText: true,
                            obscuringCharacter: "•",
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                labelText: 'ยืนยันรหัสผ่าน',
                                //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: 'กรุณากรอกรหัสผ่าน'),
                              (val) {
                                if (val != password) {
                                  return 'รหัสผ่านไม่ตรงกัน';
                                } else {
                                  return null;
                                }
                              }
                            ])),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    final isValid = _formKey.currentState.saveAndValidate();
                    if (isValid) {
                      _sendOtp(_formKey.currentState.fields['tel'].value);
                    }
                  },
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
                    child: Text(
                      "ถัดไป",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _Registration() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    //print(token);
    setState(() {
      //isLoading = true;
      // tokendata = token['data']['token'];
    });
    //print(tokendata);

    var url = Uri.parse(pathAPI + 'api/register');
    var response = await http.post(
      url,
      headers: {
        //'Content-Type': 'application/json',
        'Authorization': token['data']['token'],
      },
      body: ({
        'fname_th': _formKey.currentState.fields['thfname'].value,
        'lname_th': _formKey.currentState.fields['thflname'].value,
        'fname_en': _formKey.currentState.fields['enfname'].value,
        'lname_en': _formKey.currentState.fields['enlname'].value,
        'email': _formKey.currentState.fields['email'].value,
        'tel': _formKey.currentState.fields['tel'].value,
        'password': _formKey.currentState.fields['password'].value,
      }),
    );
    if (response.statusCode == 201) {
      print(response.body);
    } else {
      final Map<String, dynamic> addressdata =
          convert.jsonDecode(response.body);
      print(addressdata['message']);
    }
  }

  _sendOtp(String tel) async {
    var url = Uri.parse(pathAPI + 'api/sendOTP');
    var response = await http.post(
      url,
      headers: {},
      body: ({
        'tel': tel,
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> res = convert.jsonDecode(response.body);
      setState(() {
        otp_ref = res['data']['otp_ref'];
      });
      var arg = {
        'tel': _formKey.currentState.fields['tel'].value,
        'password': _formKey.currentState.fields['password'].value,
        'fname_th': _formKey.currentState.fields['thfname'].value,
        'lname_th': _formKey.currentState.fields['thlname'].value,
        'fname_en': _formKey.currentState.fields['enfname'].value,
        'lname_en': _formKey.currentState.fields['enlname'].value,
        'email': _formKey.currentState.fields['email'].value,
        'otp_ref': otp_ref,
      };
      MyNavigator.goToOtpScreen(context, arg);
    } else {}
  }
}
