import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'package:JapanThaiExpress/constants.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:io' as Io;

import 'package:url_launcher/url_launcher.dart';

class CustomerDetail extends StatefulWidget {
  CustomerDetail({Key key}) : super(key: key);

  @override
  _CustomerDetailState createState() => _CustomerDetailState();
}

class _CustomerDetailState extends State<CustomerDetail> {
  SharedPreferences prefs;
  bool isLoading = false;
  Io.File _image;
  String img64;
  final picker = ImagePicker();
  Map<String, dynamic> profilelist = {};
  String profile;
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

  var id;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routeArgs1 =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      setState(() {
        id = routeArgs1['id'];
        profile = routeArgs1['profile'];
        _fname_th = TextEditingController(
            text:
                routeArgs1['fname_th'] != "null" ? routeArgs1['fname_th'] : "");
        _lname_th = TextEditingController(
            text:
                routeArgs1['lname_th'] != "null" ? routeArgs1['lname_th'] : "");
        _fname_en = TextEditingController(
            text:
                routeArgs1['fname_en'] != "null" ? routeArgs1['fname_en'] : "");
        _lname_en = TextEditingController(
            text:
                routeArgs1['lname_en'] != "null" ? routeArgs1['lname_en'] : "");
        _email = TextEditingController(
            text: routeArgs1['email'] != "null" ? routeArgs1['email'] : "");
        _phone = TextEditingController(
            text: routeArgs1['phone'] != "null" ? routeArgs1['phone'] : "");
      });
    });
    print(id);
    // _loadData();
  }

  @override
  void dispose() {
    // other dispose methods
    _fname_th.dispose();
    _lname_th.dispose();
    _fname_en.dispose();
    _lname_en.dispose();
    _email.dispose();
    super.dispose();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        final bytes = Io.File(pickedFile.path).readAsBytesSync();
        img64 = base64Encode(bytes);
        profile = null;
      } else {
        print('No image selected.');
      }
    });
  }

  Future getcamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        final bytes = Io.File(pickedFile.path).readAsBytesSync();
        img64 = base64Encode(bytes);
        profile = null;
      } else {
        print('No image selected.');
      }
    });
  }

  _loadData() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var url = Uri.parse(pathAPI + 'api/get_member');
    var response = await http.get(
      url,
      headers: {
        //'Content-Type': 'application/json',
        'Authorization': token['data']['token']
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = convert.jsonDecode(response.body);
      //print(data['data']);
      if (data['code'] == 200) {
        setState(() {
          profilelist = data['data'];
          profile = data['data']['profile'];
          _fname_th = TextEditingController(text: profilelist['fname_th']);
          _lname_th = TextEditingController(text: profilelist['lname_th']);
          _fname_en = TextEditingController(text: profilelist['fname_en']);
          _lname_en = TextEditingController(text: profilelist['lname_en']);
          _email = TextEditingController(text: profilelist['email']);
        });
        print(profile);
      } else {
        var feedback = convert.jsonDecode(response.body);

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
    } else {
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

  _editProfile(Map<String, dynamic> values) async {
    String fname_th = _fname_th.text;
    String lname_th = _lname_th.text;
    String fname_en = _fname_en.text;
    String lname_en = _lname_en.text;
    String email = _email.text;
    String profile_img;

    //print(values);
    // print(fname_th);
    // print(lname_th);
    // print(fname_en);
    // print(lname_en);
    // print(email);
    // //print(img64);
    // print(profile);

    if (profile != null) {
      setState(() {
        profile_img = "";
        //isLoading = true;
      });
    } else {
      setState(() {
        profile_img = "data:image/png;base64," + img64;
        //isLoading = true;
      });
      //print(profile_img);
    }

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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("โปรไฟล์ลูกค้า"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: height * 0.88,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(
                  scrollDirection: Axis.vertical,
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    SizedBox(height: 20),
                    Center(
                        child: Stack(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          //color: Colors.blue,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            //color: Color(0xFFe0f2f1),
                          ),
                          child: profile == null && _image == null
                              ? ClipOval(
                                  child: Image.network(
                                  'https://via.placeholder.com/150',
                                  fit: BoxFit.cover,
                                  width: width * 0.50,
                                  height: height * 0.25,
                                ))
                              : _image != null
                                  ? ClipOval(
                                      child: Image.file(
                                        _image,
                                        fit: BoxFit.cover,
                                        width: width * 0.50,
                                        height: height * 0.25,
                                      ),
                                    )
                                  : ClipOval(
                                      child: Image.network(
                                        profile,
                                        fit: BoxFit.cover,
                                        width: width * 0.50,
                                        height: height * 0.25,
                                      ),
                                    ),
                        ),
                      ],
                    )),
                    SizedBox(height: 10),
                    FormBuilder(
                        key: _formKey,
                        initialValue: {
                          'fname_th': '',
                          'lname_th': '',
                          'fname_en': '',
                          'lname_en': '',
                          'email': '',
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "ชื่อ (ภาษาไทย)",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(height: 10),
                            FormBuilderTextField(
                              name: 'fname_th',
                              controller: _fname_th,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: 'ชื่อ(ภาษาไทย)',
                                //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true,
                                errorText:
                                    _validate_nameth ? '*กรุณากรอกชื่อ*' : null,
                              ),

                              // validator: FormBuilderValidators.compose([
                              //   FormBuilderValidators.required(context,
                              //       errorText: 'กรุณากรอกชื่อ'),
                              //   // FormBuilderValidators.numeric(context),
                              //   // FormBuilderValidators.max(context, 70),
                              // ]),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "นามสกุล (ภาษาไทย)",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(height: 10),
                            FormBuilderTextField(
                              name: 'lname_th',
                              controller: _lname_th,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: 'นามสกุล(ภาษาไทย)',
                                //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true,
                                errorText: _validate_lnameth
                                    ? '*กรุณากรอกนามสกุล*'
                                    : null,
                              ),
                              // validator: FormBuilderValidators.compose([
                              //   FormBuilderValidators.required(context,
                              //       errorText: 'กรุณากรอกนามสกุล'),
                              //   // FormBuilderValidators.numeric(context),
                              //   // FormBuilderValidators.max(context, 70),
                              // ]),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "ชื่อ (ภาษาอังกฤษ)",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(height: 10),
                            FormBuilderTextField(
                              name: 'fname_en',
                              controller: _fname_en,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: 'ชื่อ(ภาษาอังกฤษ)',
                                //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true,
                                errorText:
                                    _validate_nameen ? '*กรุณากรอกชื่อ*' : null,
                              ),
                              // validator: FormBuilderValidators.compose([
                              //   FormBuilderValidators.required(context,
                              //       errorText: 'กรุณากรอกชื่อ'),
                              //   // FormBuilderValidators.numeric(context),
                              //   // FormBuilderValidators.max(context, 70),
                              // ]),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "นามสกุล (ภาษาอังกฤษ)",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(height: 10),
                            FormBuilderTextField(
                              name: 'lname_en',
                              controller: _lname_en,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: 'นามสกุล(ภาษาอังกฤษ)',
                                //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true,
                                errorText: _validate_lnameen
                                    ? '*กรุณากรอกนามสกุล*'
                                    : null,
                              ),
                              // validator: FormBuilderValidators.compose([
                              //   FormBuilderValidators.required(context,
                              //       errorText: 'กรุณากรอกนามสกุล'),
                              //   // FormBuilderValidators.numeric(context),
                              //   // FormBuilderValidators.max(context, 70),
                              // ]),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "อีเมล",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            FormBuilderTextField(
                              name: 'email',
                              controller: _email,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                labelText: 'อีเมล',
                                //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true,
                                errorText: _validate_email
                                    ? '*กรุณากรอกที่อยู่อีเมล*'
                                    : null,
                              ),

                              // validator: FormBuilderValidators.compose([
                              //   FormBuilderValidators.required(context,
                              //       errorText: 'กรุณากรอกอีเมล'),
                              //   // FormBuilderValidators.numeric(context),
                              //   // FormBuilderValidators.max(context, 70),
                              // ]),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "เบอร์โทร",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            FormBuilderTextField(
                              name: 'phone',
                              controller: _phone,
                              decoration: InputDecoration(
                                prefixIcon: GestureDetector(
                                    onTap: () {
                                      launch("tel://" + _phone.text);
                                    },
                                    child: Icon(Icons.phone)),
                                labelText: 'เบอร์โทร',
                                //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true,
                                errorText: _validate_email
                                    ? '*กรุณากรอกเบอร์โทร*'
                                    : null,
                              ),

                              // validator: FormBuilderValidators.compose([
                              //   FormBuilderValidators.required(context,
                              //       errorText: 'กรุณากรอกอีเมล'),
                              //   // FormBuilderValidators.numeric(context),
                              //   // FormBuilderValidators.max(context, 70),
                              // ]),
                            ),
                          ],
                        )),
                    // SizedBox(height: 20),
                    // GestureDetector(
                    //   onTap: () {
                    //     // if (_formKey.currentState.validate()) {
                    //     //   _formKey.currentState.save();
                    //     //   setState(() {
                    //     //     isLoading = true;
                    //     //   });
                    //     //   _editProfile();
                    //     // } else {}

                    //     _formKey.currentState.save();
                    //     setState(() {
                    //       _fname_th.text.isEmpty
                    //           ? _validate_nameth = true
                    //           : _validate_nameth = false;
                    //       _lname_th.text.isEmpty
                    //           ? _validate_lnameth = true
                    //           : _validate_lnameth = false;
                    //       _fname_en.text.isEmpty
                    //           ? _validate_nameen = true
                    //           : _validate_nameen = false;
                    //       _lname_en.text.isEmpty
                    //           ? _validate_lnameen = true
                    //           : _validate_lnameen = false;
                    //       _email.text.isEmpty
                    //           ? _validate_email = true
                    //           : _validate_email = false;
                    //     });
                    //     if (_validate_nameth != true &&
                    //         _validate_lnameth != true &&
                    //         _validate_nameen != true &&
                    //         _validate_lnameen != true &&
                    //         _validate_email != true) {
                    //       setState(() {
                    //         isLoading = true;
                    //       });
                    //       _editProfile(_formKey.currentState.value);
                    //     } else {
                    //       print("5555");
                    //     }
                    //   },
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width,
                    //     padding: EdgeInsets.symmetric(vertical: 15),
                    //     alignment: Alignment.center,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.all(Radius.circular(5)),
                    //       boxShadow: <BoxShadow>[
                    //         BoxShadow(
                    //             color: Colors.grey.shade200,
                    //             offset: Offset(2, 4),
                    //             blurRadius: 5,
                    //             spreadRadius: 2)
                    //       ],
                    //       gradient: LinearGradient(
                    //           begin: Alignment.centerLeft,
                    //           end: Alignment.centerRight,
                    //           colors: [Color(0xffdd4b39), Color(0xffdd4b39)]),
                    //     ),
                    //     child: isLoading == true
                    //         ? Center(
                    //             child: CircularProgressIndicator(),
                    //           )
                    //         : Text(
                    //             "บันทึก",
                    //             style: TextStyle(
                    //                 fontSize: 20, color: Colors.white),
                    //           ),
                    //   ),
                    // ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
