import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotiDetailScreen extends StatefulWidget {
  NotiDetailScreen({Key key}) : super(key: key);

  @override
  _NotiDetailScreenState createState() => _NotiDetailScreenState();
}

class _NotiDetailScreenState extends State<NotiDetailScreen> {
  List<bool> checked = [true, true, false, false, true];
  SharedPreferences prefs;
  bool isLoading = false;
  bool uploadStatus = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("รายละเอียดการแจ้งเตือน"),
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("หัวข้อ"),
                          TextFormField(
                            //initialValue: '0.32 / 1 Bath',
                            decoration: InputDecoration(
                              //labelText: 'Label text',
                              //errorText: 'Error message',
                              hintText: "หัวข้อ",
                              border: OutlineInputBorder(),
                            ),
                            initialValue: data['title'],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("ประเภท"),
                          TextFormField(
                            //initialValue: '0.32 / 1 Bath',
                            decoration: InputDecoration(
                              //labelText: 'Label text',
                              //errorText: 'Error message',
                              hintText: "ประเภท",
                              border: OutlineInputBorder(),
                            ),
                            initialValue: data['type'],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("รายละเอียด"),
                          TextFormField(
                            //initialValue: '0.32 / 1 Bath',
                            maxLines: 5,
                            decoration: InputDecoration(
                              //labelText: 'Label text',
                              //errorText: 'Error message',
                              hintText: "รายละเอียด",
                              border: OutlineInputBorder(),
                            ),
                            initialValue: data['description'],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("วันที่เวลา"),
                          TextFormField(
                            //initialValue: '0.32 / 1 Bath',
                            decoration: InputDecoration(
                              //labelText: 'Label text',
                              //errorText: 'Error message',
                              hintText: "วันที่เวลา",
                              border: OutlineInputBorder(),
                            ),
                            initialValue: data['created_at'],
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
}
