import 'package:JapanThaiExpress/AdminScreens/Customer/CustomerScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/Deposit/DepositDetailScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/Deposit/DepositScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/HomeServices/HomeServices.dart';
import 'package:JapanThaiExpress/AdminScreens/Maintain/MaintainScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/Message/MessageScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/PreOders/PreoderScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/PurchaseOrders/PrechaseScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:JapanThaiExpress/AdminScreens/QRCodeScan/QRView.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> dashboard = {};
  bool isLoading = false;
  SharedPreferences prefs;

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
          Flushbar(
            //title: '${feedback['message']}',
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.FLOATING,
            message: '${dashboarddata['message']}',
            backgroundColor: Colors.greenAccent,
            icon: Icon(
              Icons.error,
              size: 28.0,
              color: Colors.white,
            ),
            duration: Duration(seconds: 3),
            leftBarIndicatorColor: Colors.blue[300],
          )..show(context);
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
        title: Text("ระบบบริการงาน JPEX"),
        automaticallyImplyLeading: false,
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
                    dashboardItem("รายการสั่งซื้อ", Icons.list_alt, 1, context),
                    Positioned(
                      right: 70,
                      left: 100,
                      top: 0,
                      bottom: 95,
                      child: dashboard['order'] != 0
                          ? Container(
                              //color: Colors.red,
                              // height: 60,
                              // width: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                                //color: Color(0xFFe0f2f1),
                              ),
                              child: Center(
                                  child: Text(dashboard['order'].toString(),
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
                  Stack(
                    children: [
                      dashboardItem("คำขอบริการ", Icons.list_alt, 2, context),
                      Positioned(
                        right: 70,
                        left: 100,
                        top: 0,
                        bottom: 95,
                        child: dashboard['service'] != 0
                            ? Container(
                                //color: Colors.red,
                                // height: 60,
                                // width: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                  //color: Color(0xFFe0f2f1),
                                ),
                                child: Center(
                                    child: Text(dashboard['service'].toString(),
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
                    ],
                  ),
                  dashboardItem(
                      "เรทบริการ", Icons.monetization_on_outlined, 3, context),
                  Stack(children: [
                    dashboardItem(
                        "รายการเติมเงิน", Icons.payments_outlined, 4, context),
                    Positioned(
                      right: 70,
                      left: 100,
                      top: 0,
                      bottom: 95,
                      child: dashboard['wallet'] != 0
                          ? Container(
                              //color: Colors.red,
                              // height: 60,
                              // width: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                                //color: Color(0xFFe0f2f1),
                              ),
                              child: Center(
                                  child: Text(dashboard['wallet'].toString(),
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
                  dashboardItem("ข้อมูลลูกค้า",
                      Icons.supervised_user_circle_outlined, 5, context),
                  dashboardItem("QR Scan", Icons.qr_code, 6, context),
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
      borderRadius: BorderRadius.circular(20.0),
    ),
    elevation: 5.0,
    margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
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
                MaterialPageRoute(builder: (context) => PrechaseScreen()));
          } else if (page == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomeServices()));
          } else if (page == 3) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MaintainScreen()));
          } else if (page == 4) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DepositScreen()));
          } else if (page == 5) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CustomerScreen()));
          } else if (page == 6) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => QRViewExample()));
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
