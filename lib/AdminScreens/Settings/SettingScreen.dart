import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:JapanThaiExpress/constants.dart';

import '../../utils/my_navigator.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isLoading = false;
  int id;

  final _formKey = GlobalKey<FormBuilderState>();
  SharedPreferences prefs;
  String tokendata = "";
  List<dynamic> SettingData = []; //ประกาศตัวแปร อาร์เรย์ ไว้
  int totalResults = 0;
  int page = 1;
  int pageSize = 10;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<String> settingMemeberName = [];

  TextEditingController address_thai;
  TextEditingController address_japan;
  TextEditingController jt_account;
  TextEditingController jt_bank;
  TextEditingController jt_branch;
  TextEditingController jt_number;
  TextEditingController jt_promptpay;

  @override
  void initState() {
    super.initState();
    _getSetting();
  }

  _getSetting() async {
    setState(() {
      isLoading = true;
    });
    try {
      prefs = await SharedPreferences.getInstance();
      var tokenString = prefs.getString('token');
      var token = convert.jsonDecode(tokenString);
      var url = Uri.parse(pathAPI + 'api/setting_app');
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token['data']['token']
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> depdata = convert.jsonDecode(response.body);
        var Data = convert.jsonDecode(response.body);
        var familyMembers = Data["data"];

        setState(() {
          address_thai =
              TextEditingController(text: Data['data']['address_thai']);
          address_japan =
              TextEditingController(text: Data['data']['address_japan']);
          jt_account = TextEditingController(text: Data['data']['jt_account']);
          jt_number = TextEditingController(text: Data['data']['jt_number']);
          jt_bank = TextEditingController(text: Data['data']['jt_bank']);
          jt_branch = TextEditingController(text: Data['data']['jt_branch']);
          jt_promptpay =
              TextEditingController(text: Data['data']['jt_promptpay']);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('error from backend ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // _setSetting() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   var url = Uri.parse(pathAPI + 'api/login_pin_mobile');
  //   var response = await http.post(url,
  //       headers: {'Content-Type': 'application/json'},
  //       // body: convert.jsonEncode({
  //       //   'pin': number,
  //       //   'device': identifier,
  //       // }));
  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> body = convert.jsonDecode(response.body);
  //     if (body['code'] == 200) {
  //       return false;
  //     } else {
  //       var feedback = convert.jsonDecode(response.body);
  //     }
  //   } else {
  //     var feedback = convert.jsonDecode(response.body);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ตั้งค่าข้อมูล"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              MyNavigator.goToAdmin(context);
            }),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          _divider("ข้อมูลบริษัท"),
                          SizedBox(
                            height: 5,
                          ),
                          Text("ที่อยู่ไทย"),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: address_thai,
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
                          Text("ที่อยู่ญี่ปุ่น"),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: address_japan,
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
                          _divider("บัญชีบริษัท"),
                          SizedBox(
                            height: 5,
                          ),
                          Text("ชื่อบัญชีบริษัท"),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: jt_account,
                            decoration: InputDecoration(
                              //labelText: 'Label text',
                              //errorText: 'Error message',
                              hintText: "",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          Text("เลขที่บัญชี"),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: jt_number,
                            decoration: InputDecoration(
                              //labelText: 'Label text',
                              //errorText: 'Error message',
                              hintText: "",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          Text("ธนาคาร"),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: jt_bank,
                            decoration: InputDecoration(
                              //labelText: 'Label text',
                              //errorText: 'Error message',
                              hintText: "",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          Text("สาขา"),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: jt_branch,
                            decoration: InputDecoration(
                              //labelText: 'Label text',
                              //errorText: 'Error message',
                              hintText: "",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          Text("พร้อมเพล"),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: jt_promptpay,
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
                          Container(
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
                            child: GestureDetector(
                              onTap: () {
                                print('1234');
                              },
                              child: Text(
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
