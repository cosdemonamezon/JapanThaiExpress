import 'dart:async';

import 'dart:io';

import 'package:JapanThaiExpress/UserScreens/Profile/ProfileScreen.dart';
import 'package:JapanThaiExpress/alert.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:flutter/material.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
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
      print(data['data']['profile']);
      setState(() {
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
    Size size = MediaQuery.of(context).size;

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
                    Text(
                      "ชื่อ(ภาษาไทย)",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      //name: 'email',
                      //keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'ชื่อ',
                          //border: InputBorder.none,
                          border: OutlineInputBorder(),
                          fillColor: Color(0xfff3f3f4),
                          filled: true),
                      /*validator: TextFormField.compose([
                                  TextFormField.required(context),
                              ])*/
                    ),
                    SizedBox(height: 10),
                    Text(
                      "นามสกุล(ภาษาไทย)",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      //name: 'email',
                      //keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'นามสกุล',
                          //border: InputBorder.none,
                          border: OutlineInputBorder(),
                          fillColor: Color(0xfff3f3f4),
                          filled: true),
                      /*validator: TextFormField.compose([
                                  TextFormField.required(context),
                              ])*/
                    ),
                    SizedBox(height: 10),
                    Text(
                      "ชื่อ(ภาษาอังกฤษ)",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      //name: 'email',
                      //keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Name',
                          //border: InputBorder.none,
                          border: OutlineInputBorder(),
                          fillColor: Color(0xfff3f3f4),
                          filled: true),
                      /*validator: TextFormField.compose([
                                  TextFormField.required(context),
                              ])*/
                    ),
                    SizedBox(height: 10),
                    Text(
                      "นามสกุล(ภาษาอังกฤษ)",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      //name: 'email',
                      //keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Lastname',
                          //border: InputBorder.none,
                          border: OutlineInputBorder(),
                          fillColor: Color(0xfff3f3f4),
                          filled: true),
                      /*validator: TextFormField.compose([
                                  TextFormField.required(context),
                              ])*/
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Email Address",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      //name: 'email',
                      //keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'Email Address',
                          //border: InputBorder.none,
                          border: OutlineInputBorder(),
                          fillColor: Color(0xfff3f3f4),
                          filled: true),
                      /*validator: TextFormField.compose([
                                  TextFormField.required(context),
                              ])*/
                    ),
                    SizedBox(height: 20),
                    /*Container(
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
                    ),*/
                    //SizedBox(height: 10),
                    TextButton(
                      child: Text('บันทึก'),
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.deepOrange[800],
                        onSurface: Colors.grey,
                        textStyle: TextStyle(
                          fontSize: 20,
                          height: 1.8,
                        ),
                      ),
                      onPressed: () {
                        String picSuccess = "assets/success.png";
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => alertProfilescreen(
                            'ดำเนินการสำเร็จ',
                            picSuccess,
                            context,
                          ),
                        );
                        // _formKey.currentState.save();
                        // print(_formKey.currentState.value);
                        //_preorderMem(_formKey.currentState.value);
                      },
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
