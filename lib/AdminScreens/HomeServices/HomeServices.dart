import 'package:JapanThaiExpress/AdminScreens/Auction/Auctionadmin.dart';
import 'package:JapanThaiExpress/AdminScreens/Customer/CustomerScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/Deposit/DepositDetailScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/Deposit/DepositScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/Depository/DepositoryScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/Exchange/ExchangeScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/Maintain/MaintainScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/Message/MessageScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/PreOders/PreoderScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/PurchaseOrders/PurchaseScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:JapanThaiExpress/AdminScreens/QRCodeScan/QRView.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../PreOders/PreoderScreen.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class HomeServices extends StatefulWidget {
  HomeServices({Key key}) : super(key: key);

  @override
  _HomeServicesState createState() => _HomeServicesState();
}

class _HomeServicesState extends State<HomeServices> {
  bool isLoading = false;
  SharedPreferences prefs;
  Map<String, dynamic> dashboard = {};

  @override
  void initState() {
    super.initState();
    _getDashboard();
  }

  _getDashboard() async {
    try {
      prefs = await SharedPreferences.getInstance();
      var tokenString = prefs.getString('token');
      var token = convert.jsonDecode(tokenString);
      var url = Uri.parse(pathAPI + 'api/app/dashboard');
      var response = await http.get(
        url,
        headers: {
          //'Content-Type': 'application/json',
          'Authorization': token['data']['token']
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> dashboarddata =
            convert.jsonDecode(response.body);
        if (dashboarddata['code'] == 200) {
          setState(() {
            dashboard = dashboarddata['data'];
            isLoading = false;
          });
          print(dashboard);
          // Flushbar(
          //   //title: '${feedback['message']}',
          //   flushbarPosition: FlushbarPosition.TOP,
          //   flushbarStyle: FlushbarStyle.FLOATING,
          //   message: '${dashboarddata['message']}',
          //   backgroundColor: Colors.greenAccent,
          //   icon: Icon(
          //     Icons.error,
          //     size: 28.0,
          //     color: Colors.white,
          //   ),
          //   duration: Duration(seconds: 3),
          //   leftBarIndicatorColor: Colors.blue[300],
          // )..show(context);
        } else {
          Flushbar(
            title: '${dashboarddata['message']}',
            message: 'รหัสข้อผิดพลาด : ${dashboarddata['code']}',
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
        setState(() {
          isLoading = false;
        });
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
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("คำขอบริการ"),
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              MyNavigator.goToHomeScreen(context);
            }),
      ),
      body: Container(
        height: height,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(3.0),
                children: [
                  Stack(children: [
                    dashboardItem("รายการฝากซื้อ", Icons.shopping_cart_rounded,
                        1, context),
                    Positioned(
                      right: 70,
                      left: 100,
                      top: 0,
                      bottom: 95,
                      child: dashboard['preorder'] != 0
                          ? CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.red,
                              child: Center(
                                  child: dashboard['preorder'] != null
                                      ? Text(dashboard['preorder'].toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white,
                                          ))
                                      : Text("0",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white,
                                          ))),
                            )
                          : SizedBox(
                              height: 2,
                            ),
                    ),
                  ]),
                  Stack(children: [
                    dashboardItem("รายการฝากส่ง", Icons.local_shipping_rounded,
                        2, context),
                    Positioned(
                      right: 70,
                      left: 100,
                      top: 0,
                      bottom: 95,
                      child: dashboard['depository'] != 0
                          ? CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.red,
                              child: Center(
                                  child: dashboard['depository'] != null
                                      ? Text(dashboard['depository'].toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white,
                                          ))
                                      : Text("0",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white,
                                          ))),
                            )
                          : SizedBox(
                              height: 2,
                            ),
                    ),
                  ]),
                  Stack(children: [
                    dashboardItem(
                        "รายการฝากโอน", Icons.local_atm_rounded, 3, context),
                    Positioned(
                      right: 70,
                      left: 100,
                      top: 0,
                      bottom: 95,
                      child: dashboard['exchange'] != 0
                          ? CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.red,
                              child: Center(
                                  child: dashboard['exchange'] != null
                                      ? Text(dashboard['exchange'].toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white,
                                          ))
                                      : Text("0",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white,
                                          ))),
                            )
                          : SizedBox(
                              height: 2,
                            ),
                    ),
                  ]),
                  Stack(children: [
                    dashboardItem("รายการประมูล", Icons.monetization_on_rounded,
                        4, context),
                    Positioned(
                      right: 70,
                      left: 100,
                      top: 0,
                      bottom: 95,
                      child: dashboard['auction'] != 0
                          ? CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.red,
                              child: Center(
                                  child: dashboard['auction'] != null
                                      ? Text(dashboard['auction'].toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white,
                                          ))
                                      : Text("0",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white,
                                          ))),
                            )
                          : SizedBox(
                              height: 2,
                            ),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navigation(),
    );
  }
}

Card dashboardItem(String title, IconData icon, int page, context) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    elevation: 5.0,
    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 3,
          color: Color(0xFFfafafa),
          //color: Color(0xFF343434),
          //color: Color(0xFFd73925),
        ),
        color: Color(0xFFfafafa),
        //color: Color(0xFFd73925),
        borderRadius: BorderRadius.circular(15),
      ),
      child: new InkWell(
        onTap: () {
          if (page == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PreoderScreen()));
          } else if (page == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DepositoryScreen()));
          } else if (page == 3) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ExchangeScreen()));
          } else if (page == 4) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Auctionadmin()));
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          verticalDirection: VerticalDirection.down,
          children: [
            SizedBox(height: 20.0),
            Center(
              child: Icon(
                icon,
                size: 60.0,
                color: Color(0xFFd73925),
              ),
            ),
            SizedBox(height: 20.0),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  title,
                  style:
                      new TextStyle(fontSize: 15.0, color: Color(0xFFd73925)),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
