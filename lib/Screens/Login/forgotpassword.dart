import 'package:JapanThaiExpress/alert.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:io' as Io;
import 'dart:convert';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Forgotpassword extends StatefulWidget {
  Forgotpassword({Key key}) : super(key: key);

  @override
  _ForgotpasswordState createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  String password;
  String confirmpassword;
  bool isLoading = false;
  final _formKey = GlobalKey<FormBuilderState>();
  //final _formKey1 = GlobalKey<FormBuilderState>();
  SharedPreferences prefs;
  Map<String, dynamic> _data;
  _changePassword(Map<String, dynamic> values) async {
    print(values);

    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var url = Uri.parse(pathAPI + 'api/reset_password');
    var response = await http.post(url,
        headers: {
          //'Content-Type': 'application/json',
          //'Authorization': token['data']['token']
        },
        body: ({
          'tel': _data['tel'],
          'password': values['password'],
        }));

    if (response.statusCode == 200) {
      final Map<String, dynamic> editdata = convert.jsonDecode(response.body);
      if (editdata['code'] == 200) {
        print(editdata['message']);
        String feedback = editdata['message'];
        Flushbar(
          //title: 'ดำเนินการสำเร็จ',
          message: feedback,
          backgroundColor: Colors.greenAccent,
          icon: Icon(
            Icons.error,
            size: 28.0,
            color: Colors.white,
          ),
          leftBarIndicatorColor: Colors.blue[300],
          duration: Duration(seconds: 5),
        )..show(context);

        setState(() {
          isLoading = false;
        });
        Future.delayed(Duration(seconds: 3), () {
          MyNavigator.goToLogin(context);
        });
      } else {
        String feedback = editdata['message'];
        Flushbar(
          //title: 'ดำเนินการสำเร็จ',
          message: feedback,
          backgroundColor: Colors.greenAccent,
          icon: Icon(
            Icons.error,
            size: 28.0,
            color: Colors.white,
          ),
          leftBarIndicatorColor: Colors.blue[300],
          duration: Duration(seconds: 3),
        )..show(context);
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print("error");
      var feedback = convert.jsonDecode(response.body);
      print("${feedback['message']}");
      Flushbar(
        title: '${feedback['message']}',
        message: 'รหัสข้อผิดพลาด : ${feedback['code']}',
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
    Map data = ModalRoute.of(context).settings.arguments; 
    setState(() {
      _data = data;
    });
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * .01),
                FormBuilder(
                  key: _formKey,
                  initialValue: {
                 
                    'password': '',
                    'confirmpassword': '',
                  },
                  child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            "รหัสผ่านใหม่",
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
                                  labelText: 'รหัสผ่านใหม่',
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
                          SizedBox(height: 25),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState.saveAndValidate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                // _formKey.currentState.save();
                                _changePassword(_formKey.currentState.value);
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
                          SizedBox(height: 10),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
