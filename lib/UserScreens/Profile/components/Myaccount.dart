import 'dart:async';

import 'dart:io';

import 'package:JapanThaiExpress/UserScreens/Profile/ProfileScreen.dart';
import 'package:JapanThaiExpress/alert.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:flutter/material.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Myaccount extends StatefulWidget {
  Myaccount({Key key}) : super(key: key);

  @override
  _MyaccountState createState() => _MyaccountState();
}

class _MyaccountState extends State<Myaccount> {
  SharedPreferences prefs;
  File _image;
  final picker = ImagePicker();
  String profile;
  final _formKey = GlobalKey<FormBuilderState>();

  String _fname_th;
  String _lname_th;
  String _fname_en;
  String _lname_en;
  String _email;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
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
      print(data['data']);
      setState(() {
        _fname_th = data['data']['fname_th'];
        _lname_th = data['data']['lname_th'];
        _fname_en = data['data']['fname_en'];
        _lname_en = data['data']['lname_en'];
        _email = data['data']['email'];
        profile = data['data']['profile'];
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("แก้ไขโปรไฟล์"),
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
                          child: CircleAvatar(
                            backgroundImage: profile == null
                                ? NetworkImage(
                                    'https://via.placeholder.com/150')
                                : NetworkImage(profile),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 0,
                                color: Color(0xFFF5F6F9),
                              ),
                              color: Colors.deepOrange,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.camera_alt),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Wrap(children: [
                                    ListTile(
                                      leading: Icon(Icons.camera_alt),
                                      title: Text('Camera'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        getcamera();
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.photo_album),
                                      title: Text('Gallery'),
                                      onTap: () {
                                        // Navigator.pop(context);
                                        getImage();
                                      },
                                    ),
                                  ]),
                                );
                              },
                              color: Colors.white,
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
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  labelText: 'ชื่อ(ภาษาไทย)',
                                  //border: InputBorder.none,
                                  border: OutlineInputBorder(),
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true),
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
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  labelText: 'นามสกุล(ภาษาไทย)',
                                  //border: InputBorder.none,
                                  border: OutlineInputBorder(),
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true),
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
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  labelText: 'ชื่อ(ภาษาอังกฤษ)',
                                  //border: InputBorder.none,
                                  border: OutlineInputBorder(),
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true),
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
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  labelText: 'นามสกุล(ภาษาอังกฤษ)',
                                  //border: InputBorder.none,
                                  border: OutlineInputBorder(),
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "อีเมล",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            FormBuilderTextField(
                              name: 'email',
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.email),
                                  labelText: 'อีเมล',
                                  //border: InputBorder.none,
                                  border: OutlineInputBorder(),
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true),
                            ),
                          ],
                        )),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {},
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
                          "บันทึก",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
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
