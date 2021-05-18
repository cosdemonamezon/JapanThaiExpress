import 'package:JapanThaiExpress/UserScreens/MyOders/OdersScreen.dart';
import 'package:JapanThaiExpress/UserScreens/News/NewsScreen.dart';
import 'package:JapanThaiExpress/UserScreens/Products/ProductScreen.dart';
import 'package:JapanThaiExpress/UserScreens/Profile/ProfileScreen.dart';
import 'package:JapanThaiExpress/UserScreens/Promotion/PromotionScreen.dart';
import 'package:JapanThaiExpress/UserScreens/Service/Service.dart';
import 'package:JapanThaiExpress/UserScreens/Wallet/WalletScreen.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class DashbordScreen extends StatefulWidget {
  DashbordScreen({Key key}) : super(key: key);

  @override
  _DashbordScreenState createState() => _DashbordScreenState();
}

class _DashbordScreenState extends State<DashbordScreen> {
  SharedPreferences prefs;
  Map<String, dynamic> dashboard = {};
  bool isLoading = false;

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
        automaticallyImplyLeading: false,
        title: Text("JapanThaiExpress"),
        
      ),
      body: Container(
        height: height,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(3.0),
                children: [
                  Stack(
                    children: [
                      dashboardItem("รายการซื้อสินค้า", Icons.add_shopping_cart,
                          1, context),
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
                    ],
                  ),
                  Stack(
                    children: [
                      dashboardItem("บริการของเรา",
                          Icons.local_shipping_outlined, 2, context),
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
                  dashboardItem("สินค้า", Icons.store_outlined, 3, context),
                  Stack(
                    children: [
                      dashboardItem("กระเป๋าสตางค์",
                          Icons.account_balance_wallet_outlined, 4, context),
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
                    ],
                  ),
                  dashboardItem("ข่าว", Icons.web_outlined, 5, context),
                  dashboardItem("โปรโมชั่น", Icons.redeem, 6, context),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(),
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
            MyNavigator.goToMyOrder(context);
          } else if (page == 2) {
            MyNavigator.goToService(context);
          } else if (page == 3) {
            MyNavigator.goToProductScreen(context);
          } else if (page == 4) {
            MyNavigator.goToWallet(context);
          } else if (page == 5) {
            MyNavigator.goToNews(context);
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => NewsScreen()));
          } else if (page == 6) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PromotionScreen()));
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                      new TextStyle(fontSize: 20.0, color: Color(0xFFd73925)),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
