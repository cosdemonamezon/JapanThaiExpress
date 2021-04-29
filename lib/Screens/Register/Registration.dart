import 'package:JapanThaiExpress/Screens/Register/OtpScreen.dart';
import 'package:JapanThaiExpress/Screens/Register/SetPin.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:JapanThaiExpress/constants.dart';

// ignore: must_be_immutable
class Registration extends StatefulWidget {
  Registration({Key key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormBuilderState>();
  SharedPreferences prefs;
  String fname_th;
  String lname_th;
  String email;
  String tel;
  String password;
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
                    'name': '',
                    'lname': '',
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
                          "ชื่อ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        FormBuilderTextField(
                            name: 'name',
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: 'ชื่อ(ภาษาไทย)',
                                //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: 'กรุณากรอกชื่อ'),
                            ])),
                        SizedBox(height: 10),
                        Text(
                          "นามสกุล",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        FormBuilderTextField(
                            name: 'lname',
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: 'นามสกุล(ภาษาไทย)',
                                //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: 'กรุณากรอกนามสกุล'),
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
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: 'กรุณากรอกรหัสผ่าน'),
                              // FormBuilderValidators.equal(
                              //     context,
                              //     _formKey.currentState
                              //         .fields['confirmpassword'].value,
                              //     errorText: 'รหัสผ่านไม่ตรงกัน'),
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
                                  errorText: 'กรุณากรอกยืนยันรหัสผ่าน'),
                              // FormBuilderValidators.equal(
                              //     context,
                              //     _formKey
                              //         .currentState.fields['password'].value,
                              //     errorText: 'รหัสผ่านไม่ตรงกัน'),
                            ])),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // _formKey.currentState.save();
                    // var arg = {'tel': '0859908017'};

                    print(_formKey.currentState.value);
                    // MyNavigator.goToOtpScreen(context, arg);
                    // print(arg);
                    // final isValid = _formKey.currentState.saveAndValidate();
                    // if (isValid) {
                    //   var arg = _formKey.currentState.value;
                    //   // Navigator.push(context,
                    //   //     MaterialPageRoute(builder: (context) {
                    //   //   return OtpScreen();
                    //   // }));
                    // }
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
        'fname_th': _formKey.currentState.fields['name'].value,
        'lname_th': _formKey.currentState.fields['lname'].value,
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
}
