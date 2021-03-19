import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/japanexpress.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';

class DepositScreen extends StatefulWidget {
  DepositScreen({Key key}) : super(key: key);

  @override
  _DepositScreenState createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  SharedPreferences prefs;
  SharedPreferences prefsNoti;
  bool isLoading = false;
  Map<String, dynamic> data = {};
  List<dynamic> notidata = [];
  Map<String, dynamic> readnotidata = {};
  Map<String, dynamic> numberNoti = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getList();
  }

  _readNotiMember() {}

  _getList() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      isLoading = true;
    });
    var url = pathAPI + 'api/transaction_list';
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token['data']['token']
      },
    );
    if (response.statusCode == 200) {
      //print(response.statusCode);
      final Map<String, dynamic> notinumber = convert.jsonDecode(response.body);
      //print(notinumber);
      if (notinumber['code'] == 200) {
        setState(() {
          notidata = notinumber['data'];
          setState(() {
            isLoading = false;
          });
        });

        //print(notidata.length);
      } else {
        String title = "ข้อผิดพลาดภายในเซิร์ฟเวอร์";
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => dialogDenied(
            title,
            picDenied,
            context,
          ),
        );
      }
    } else {
      final Map<String, dynamic> notinumber = convert.jsonDecode(response.body);

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialogDenied(
          notinumber['massage'],
          picDenied,
          context,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.chevron_left),
        centerTitle: true,
        title: Text("Refill notification"),
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : notidata.length == 0
              ? Center(
                  child: Text(
                    "ไม่พบข้อมูล",
                    style: TextStyle(
                      fontSize: 30,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Container(
                  width: double.infinity,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: notidata.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                            onTap: () {
                              var arg = {
                                "account_name": notidata[index]['account_name'],
                                "amount": notidata[index]['amount'],
                                "slip": notidata[index]["slip"],
                              };
                              MyNavigator.goToDepositDetail(context, arg);
                            },
                            child: Card(
                              color: notidata[index]["status"] == "accepted"
                                  ? Colors.blue[50]
                                  : Colors.white,
                              elevation: 8.0,
                              child: ListTile(
                                leading: notidata[index]["slip"] == null
                                    ? Icon(
                                        Icons.transform_rounded,
                                        size: 40,
                                        color: kPrimaryColor,
                                      )
                                    : Container(
                                        child: Image.network(
                                        notidata[index]['slip'],
                                        fit: BoxFit.contain,
                                      )),
                                title: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: notidata[index]['account_name']
                                              .length >=
                                          30
                                      ? Text(
                                          "${notidata[index]['amount'].substring(0, 30)} ...",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400))
                                      : Text(
                                          notidata[index]['account_name'] +
                                              "\nยอดเงิน : " +
                                              notidata[index]['amount'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400)),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: notidata[index]['created_at'].length >=
                                          50
                                      ? Text(
                                          "${notidata[index]['created_at'].substring(0, 50)} ...",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400))
                                      : Text(notidata[index]['created_at'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400)),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
      bottomNavigationBar: Navigation(),
    );
  }

  Card messageCard(String title, IconData icon, String subtitle) {
    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: Color(0xffdd4b39),
          size: 40.0,
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }
}
