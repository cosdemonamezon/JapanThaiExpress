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

class DepositDetailScreen extends StatefulWidget {
  DepositDetailScreen({Key key}) : super(key: key);

  @override
  _DepositDetailScreenState createState() => _DepositDetailScreenState();
}

class _DepositDetailScreenState extends State<DepositDetailScreen> {
  List<bool> checked = [true, true, false, false, true];
  SharedPreferences prefs;
  bool isLoading = false;
  bool uploadStatus = false;

  @override
  void initState() {
    super.initState();
  }

  _updateStatusPromptpay(id, status) async {
    setState(() {
      isLoading = true;
    });
    try {
      prefs = await SharedPreferences.getInstance();
      var tokenString = prefs.getString('token');
      var token = convert.jsonDecode(tokenString);
      var url = Uri.parse(pathAPI + 'api/app/approve_qrcode/' + id);
      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token['data']['token']
          },
          body: convert.jsonEncode({
            'status': status,
          }));
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          uploadStatus = true;
        });
        Navigator.of(context, rootNavigator: true).pop(false);
      } else {
        setState(() {
          isLoading = false;
          uploadStatus = false;
        });
        Navigator.of(context, rootNavigator: true).pop(false);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        uploadStatus = false;
      });
      Navigator.of(context, rootNavigator: true).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("รายละเอียดการเติมเงิน"),
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
                    GestureDetector(
                      onTap: () {
                        launch(data['slip']);
                      },
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              height: 150,
                              decoration: BoxDecoration(),
                              child: Image.network(
                                data['slip'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text("คลิกที่รูปเพื่อขยาย"),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text("ชื่อบัญชี"),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // TextFormField(
                          //   //initialValue: '0.29 / 1 Bath',
                          //   decoration: InputDecoration(
                          //     //labelText: 'Label text',
                          //     //errorText: 'Error message',
                          //     hintText: "Account",
                          //     border: OutlineInputBorder(),
                          //   ),
                          //   initialValue: data['account_name'],
                          // ),
                          // SizedBox(
                          //   height: 30,
                          // ),
                          Text("ช่องทางเติมเงิน"),
                          TextFormField(
                            //initialValue: '0.32 / 1 Bath',
                            decoration: InputDecoration(
                              //labelText: 'Label text',
                              //errorText: 'Error message',
                              hintText: "ช่องทางเติมเงิน",
                              border: OutlineInputBorder(),
                            ),
                            initialValue: data['payment_type'],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("ยอดเงิน"),
                          TextFormField(
                            //initialValue: '0.32 / 1 Bath',
                            decoration: InputDecoration(
                              //labelText: 'Label text',
                              //errorText: 'Error message',
                              hintText: "ยอดเงิน",
                              border: OutlineInputBorder(),
                            ),
                            initialValue: data['amount'],
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
                          SizedBox(
                            height: 30,
                          ),
                          data['status'] == "รอดำเนินการ" &&
                                  uploadStatus == false
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
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
                                                Color(0xffaaaaaa),
                                                Color(0xffaaaaaa)
                                              ]),
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  new AlertDialog(
                                                title: new Text(
                                                    'ยืนยันคำสั่งอนุมัติ'),
                                                content: Text(
                                                    'กด ยืนยัน เมื่อต้องการอนุมัติรายการนี้'),
                                                actions: <Widget>[
                                                  new FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop(
                                                              false); // dismisses only the dialog and returns false
                                                    },
                                                    child: Text('ปิด',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                  FlatButton(
                                                    onPressed: () {
                                                      _updateStatusPromptpay(
                                                          data['id'],
                                                          'rejected ');
                                                    },
                                                    child: Text(
                                                      'ยืนยัน',
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xffdd4b39)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "ปฏิเสธ",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
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
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  new AlertDialog(
                                                title: new Text(
                                                    'ยืนยันคำสั่งอนุมัติ'),
                                                content: Text(
                                                    'กด ยืนยัน เมื่อต้องการอนุมัติรายการนี้'),
                                                actions: <Widget>[
                                                  new FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop(
                                                              false); // dismisses only the dialog and returns false
                                                    },
                                                    child: Text('ปิด',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                  FlatButton(
                                                    onPressed: () {
                                                      _updateStatusPromptpay(
                                                          data['id'],
                                                          'accepted ');
                                                    },
                                                    child: Text(
                                                      'ยืนยัน',
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xffdd4b39)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "อนุมัติ",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ])
                              : SizedBox(
                                  height: 1,
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
