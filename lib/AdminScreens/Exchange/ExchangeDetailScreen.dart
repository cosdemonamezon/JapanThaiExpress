import 'dart:convert';
import 'dart:io';

import 'package:JapanThaiExpress/AdminScreens/Exchange/ExchangeScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as Io;

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class ExchangeDetailScreen extends StatefulWidget {
  ExchangeDetailScreen({Key key}) : super(key: key);

  @override
  _ExchangeDetailScreenState createState() => _ExchangeDetailScreenState();
}

class _ExchangeDetailScreenState extends State<ExchangeDetailScreen> {
  List<bool> checked = [true, true, false, false, true];
  Io.File _image;
  String img64;
  final picker = ImagePicker();
  String status;
  String id;
  bool isLoading = false;
  final _formKey = GlobalKey<FormBuilderState>();
  SharedPreferences prefs;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        final bytes = Io.File(pickedFile.path).readAsBytesSync();
        img64 = base64Encode(bytes);
      } else {
        print('No image selected.');
      }
    });
  }

  _appoveExchange(Map<String, dynamic> values) async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    print(img64);
    print(values);
    print(status);
    print(id);

    var url = Uri.parse(pathAPI + 'api/appove_exchange/$id');
    var response = await http.put(url,
        headers: {
          //'Content-Type': 'application/json',
          'Authorization': token['data']['token']
        },
        body: ({
          //'amount': values['amount'],
          //'id': id,
          'slip': "data:image/png;base64," + img64,
          'status': status,
          'note': values['note'],
        }));
    if (response.statusCode == 201) {
      final Map<String, dynamic> creatdata = convert.jsonDecode(response.body);
      if (creatdata['code'] == 201) {
        setState(() {
          isLoading = false;
        });
        Flushbar(
          //title: '${creatdata['message']}',
          message: '${creatdata['message']}',
          backgroundColor: Colors.greenAccent,
          icon: Icon(
            Icons.error,
            size: 28.0,
            color: Colors.white,
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
        )..show(context);
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => ExchangeScreen()));
        });
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
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("รายละเอียดคำขอโอนเงิน"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: FormBuilder(
            key: _formKey,
            initialValue: {
              'note': '',
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: Center(
                    child: Container(
                      height: 240,
                      width: 220,
                      child: _image == null
                          ? Image.asset("assets/images/nopic.png",
                              fit: BoxFit.fill)
                          : Image.file(
                              _image,
                              fit: BoxFit.fill,
                            ),
                      //decoration: BoxDecoration(),
                      // child: Image.network(
                      //   data['slip'],
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),
                ),
                Center(
                  child: Text("*อัปโหลดสลิป*"),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("หมายเหตุ"),
                      SizedBox(
                        height: 10,
                      ),
                      FormBuilderTextField(
                        //initialValue: '0.32 / 1 Bath',
                        name: 'note',
                        maxLines: 5,
                        decoration: InputDecoration(
                          //labelText: 'Label text',
                          //errorText: 'Error message',
                          hintText: "รายละเอียด",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      for (var i = 0; i < 1; i += 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                      SizedBox(
                        height: 15,
                      ),
                      ListTile(
                        title: Row(
                          children: <Widget>[
                            Expanded(
                                child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  status = "approved";
                                  id = data['id'].toString();
                                  isLoading = true;
                                });
                                _formKey.currentState.save();
                                _appoveExchange(_formKey.currentState.value);
                              },
                              child: Text("ยืนยัน"),
                              color: Color(0xffdd4b39),
                              textColor: Colors.white,
                            )),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: RaisedButton(
                              onPressed: () {},
                              child: Text("ยกเลิก"),
                              color: Color(0xffdd4b39),
                              textColor: Colors.white,
                            )),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Navigation(),
    );
  }
}
