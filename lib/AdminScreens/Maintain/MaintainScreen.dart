import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:JapanThaiExpress/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/my_navigator.dart';

class MaintainScreen extends StatefulWidget {
  MaintainScreen({Key key}) : super(key: key);

  @override
  _MaintainScreenState createState() => _MaintainScreenState();
}

class _MaintainScreenState extends State<MaintainScreen> {
  SharedPreferences prefs;
  bool isLoading = false;
  final _formKey = GlobalKey<FormBuilderState>();

  TextEditingController _fname_th;
  TextEditingController _lname_th;
  TextEditingController _fname_en;
  TextEditingController _lname_en;
  TextEditingController _email;
  TextEditingController _phone;

  bool _validate_nameth = false;
  bool _validate_lnameth = false;
  bool _validate_nameen = false;
  bool _validate_lnameen = false;
  bool _validate_email = false;
  bool _validate_phone = false;

  _editProfile(Map<String, dynamic> values) async {
    String fname_th = _fname_th.text;
    String lname_th = _lname_th.text;
    String fname_en = _fname_en.text;
    String lname_en = _lname_en.text;
    String email = _email.text;
    String profile_img;

    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var url = Uri.parse(pathAPI + 'api/edit_member');
    var response = await http.put(url,
        headers: {
          //'Content-Type': 'application/json',
          'Authorization': token['data']['token']
        },
        body: ({
          'fname_th': fname_th,
          'lname_th': lname_th,
          'fname_en': fname_en,
          'lname_en': lname_en,
          'profile': profile_img,
          'email': email,
        }));

    if (response.statusCode == 200) {
      final Map<String, dynamic> editdata = convert.jsonDecode(response.body);
      //print(depositdata);
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
          duration: Duration(seconds: 3),
        )..show(context);

        setState(() {
          isLoading = false;
        });
        Future.delayed(Duration(seconds: 3), () {
          MyNavigator.goToProfileScreen(context);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("เรทบริการ"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              MyNavigator.goToAdmin(context);
            }),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    _divider("เงื่อนไขบริการ"),
                    SizedBox(
                      height: 5,
                    ),
                    Text("อัตราแลกเปลี่ยน (บาท)"),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: '0.32',
                      decoration: InputDecoration(
                        //labelText: 'Label text',
                        //errorText: 'Error message',
                        hintText: "",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("ค่าบริการ (เยน)"),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: '300',
                      decoration: InputDecoration(
                        //labelText: 'Label text',
                        //errorText: 'Error message',
                        hintText: "",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("ค่าบริการแลกเปลี่ยน (บาท)"),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: '0',
                      decoration: InputDecoration(
                        //labelText: 'Label text',
                        //errorText: 'Error message',
                        hintText: "",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("ค่าคอมมิชชั่น (%)"),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: '0.03',
                      decoration: InputDecoration(
                        //labelText: 'Label text',
                        //errorText: 'Error message',
                        hintText: "",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        _formKey.currentState.save();
                        setState(() {
                          _fname_th.text.isEmpty
                              ? _validate_nameth = true
                              : _validate_nameth = false;
                          _lname_th.text.isEmpty
                              ? _validate_lnameth = true
                              : _validate_lnameth = false;
                          _fname_en.text.isEmpty
                              ? _validate_nameen = true
                              : _validate_nameen = false;
                          _lname_en.text.isEmpty
                              ? _validate_lnameen = true
                              : _validate_lnameen = false;
                          _email.text.isEmpty
                              ? _validate_email = true
                              : _validate_email = false;
                        });
                        if (_validate_nameth != true &&
                            _validate_lnameth != true &&
                            _validate_nameen != true &&
                            _validate_lnameen != true &&
                            _validate_email != true) {
                          setState(() {
                            isLoading = true;
                          });
                          _editProfile(_formKey.currentState.value);
                        } else {
                          print("5555");
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
                        child: isLoading == true
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Text(
                                "บันทึก",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navigation(),
    );
  }

  _divider(String str) {
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
                thickness: 2,
                color: primaryColor,
              ),
            ),
          ),
          Text(str),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 2,
                color: primaryColor,
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
}
