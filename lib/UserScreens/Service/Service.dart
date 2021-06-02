import 'package:JapanThaiExpress/UserScreens/Dashboard/DashbordScreen.dart';
import 'package:JapanThaiExpress/UserScreens/Service/Auction.dart';
import 'package:JapanThaiExpress/UserScreens/Service/Buystuff.dart';
import 'package:JapanThaiExpress/UserScreens/Service/Deposit.dart';
import 'package:JapanThaiExpress/UserScreens/Service/ReceiveMoney.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Service extends StatefulWidget {
  Service({Key key}) : super(key: key);

  @override
  _ServiceState createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  bool isLoading = false;
  List<dynamic> banner = [];
  String tokendata = "";
  SharedPreferences prefs;
  List<String> imgPath = [];
  Map<String, dynamic> dashboard = {};

  @override
  void initState() {
    super.initState();
    _getBanners();
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
          //print(dashboard);
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

  _getBanners() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    setState(() {
      isLoading = true;
      tokendata = token['data']['token'];
    });

    var url = Uri.parse(pathAPI + 'api/banners');
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': token['data']['token']
    });
    if (response.statusCode == 200) {
      final Map<String, dynamic> imgdata = convert.jsonDecode(response.body);
      if (imgdata['code'] == 200) {
        setState(() {
          banner = imgdata['data'];
          // for (var i = 0; i < banner.length; i++) {
          //   imgPath = banner[i]['path'];
          // }
        });
        //print(banner);
      } else {}
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        //centerTitle: true,
        title: Text("บริการของเรา"),
        leading: IconButton(
            onPressed: () {
              MyNavigator.goBackUserHome(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            )),
      ),
      body: Container(
        height: height,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              //height: height*0.2,
              //color: Colors.amber,
              width: double.infinity,
              child: CarouselSlider.builder(
                  itemCount: banner.length,
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 2.1,
                    viewportFraction: 0.85,
                    enlargeCenterPage: true,
                    initialPage: 9,
                    scrollDirection: Axis.horizontal,
                    autoPlayInterval: Duration(seconds: 5),
                    autoPlayAnimationDuration: Duration(milliseconds: 3000),
                  ),
                  itemBuilder: (context, index, realIdx) {
                    if (banner.length != 0) {
                      return Container(
                        height: height * 0.55,
                        child: Center(
                          child: Image.network(
                            banner[index]['path'],
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    }
                  }),
            ),
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
                      dashboardItem(
                          "ฝากส่ง", Icons.local_shipping_outlined, 1, context),
                      dashboardItem("รับฝากส่ง", Icons.local_shipping_rounded,
                          1, context),
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
                                        ? Text(
                                            dashboard['depository'].toString(),
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
                    ],
                  ),
                  Stack(
                    children: [
                      dashboardItem(
                          "ฝากซื้อ", Icons.shopping_cart_outlined, 2, context),
                      dashboardItem("รับฝากซื้อ", Icons.shopping_cart_rounded,
                          2, context),
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
                    ],
                  ),
                  Stack(
                    children: [
                      dashboardItem("ประมูลสินค้า",
                          Icons.monetization_on_rounded, 3, context),
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
                    ],
                  ),
                  Stack(
                    children: [
                      dashboardItem(
                          "รับโอนเงิน", Icons.payments_sharp, 4, context),
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
                    ],
                  ),
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
      borderRadius: BorderRadius.circular(15.0),
    ),
    elevation: 5.0,
    margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 15.0),
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Deposit()));
          } else if (page == 2) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Buystuff()));
          } else if (page == 3) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Auction()));
          } else if (page == 4) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ReceiveMoney()));
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
                      new TextStyle(fontSize: 16.0, color: Color(0xFFd73925)),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
