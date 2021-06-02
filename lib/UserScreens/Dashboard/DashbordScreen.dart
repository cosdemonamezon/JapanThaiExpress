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
import 'package:flutter_form_builder/flutter_form_builder.dart';

class DashbordScreen extends StatefulWidget {
  DashbordScreen({Key key}) : super(key: key);

  @override
  _DashbordScreenState createState() => _DashbordScreenState();
}

class _DashbordScreenState extends State<DashbordScreen> {
  SharedPreferences prefs;
  Map<String, dynamic> dashboard = {};
  bool isLoading = false;
  final _formKey1 = GlobalKey<FormBuilderState>();
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

          var telString = prefs.getString('tel');

          if ( telString == null) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return WillPopScope(
                  onWillPop: () async => false,
                  child: addPhone(
                    context,
                  ),
                );
              },
            );
          }
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

  _addPhone(Map<String, dynamic> values) async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    print(values);
    setState(() {
      isLoading = true;
    });

    var url = Uri.parse(pathAPI + 'api/app/set_tel');
    var response = await http.post(url,
        headers: {
          //'Content-Type': 'application/json',
          'Authorization': token['data']['token']
        },
        body: ({
          'tel': values['phone'],
        }));

    if (response.statusCode == 200) {
      final Map<String, dynamic> topicdata = convert.jsonDecode(response.body);
      await prefs.setString('tel', values['phone']);
      print(prefs.getString('tel'));
      setState(() {
        isLoading = false;
      });
      // _getMessageScreenory();
      Navigator.pop(context);
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
    final height = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size;
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
                      dashboardItem("รายการซื้อสินค้า", Icons.local_grocery_store,
                          1, context),
                      Positioned(
                        right: 70,
                        left: 100,
                        top: 0,
                        bottom: 95,
                        child: dashboard['order'] != 0
                            ? CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.red,
                                child: Center(
                                    child: dashboard['order'] != null
                                        ? Text(dashboard['order'].toString(),
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
                      dashboardItem("บริการของเรา",
                          Icons.local_shipping_rounded, 2, context),
                      Positioned(
                        right: 70,
                        left: 100,
                        top: 0,
                        bottom: 95,
                        child: dashboard['service'] != 0
                            ? CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.red,
                                child: Center(
                                    child: dashboard['service'] != null
                                        ? Text(dashboard['service'].toString(),
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
                  dashboardItem("สินค้า", Icons.store_mall_directory_rounded, 3, context),
                  Stack(
                    children: [
                      dashboardItem("กระเป๋าสตางค์",
                          Icons.account_balance_wallet_rounded, 4, context),
                      Positioned(
                        right: 70,
                        left: 100,
                        top: 0,
                        bottom: 95,
                        child: dashboard['wallet'] != 0
                            ? CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.red,
                                child: Center(
                                    child: dashboard['wallet'] != null
                                        ? Text(dashboard['wallet'].toString(),
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
                  dashboardItem("ข่าว", Icons.web_rounded, 5, context),
                  dashboardItem("โปรโมชั่น", Icons.card_giftcard_rounded, 6, context),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(),
    );
  }

  addPhone(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 1,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(
            left: Constants.padding,
            top: Constants.avatarRadius - Constants.padding,
            right: Constants.padding,
            bottom: Constants.padding),
        margin: EdgeInsets.only(top: Constants.avatarRadius),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: kFontPrimaryColor,
            borderRadius: BorderRadius.circular(Constants.padding),
            boxShadow: [
              BoxShadow(
                  color: Colors.black, offset: Offset(0, 2), blurRadius: 2),
            ]),
        child: Container(
          child: SingleChildScrollView(
            child: FormBuilder(
              key: _formKey1,
              initialValue: {
                'title': '',
                'description': '',
              },
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "เบอร์โทร",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        FormBuilderTextField(
                          name: 'phone',
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              //border: InputBorder.none,
                              border: OutlineInputBorder(),
                              fillColor: Color(0xfff3f3f4),
                              hintText: 'กรุณากรอกเบอร์โทร',
                              filled: true),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: 'กรุณากรอกเบอร์โทร'),
                            FormBuilderValidators.numeric(context),
                            FormBuilderValidators.maxLength(context, 10,
                                errorText:
                                    "กรุณากรอกเบอร์โทรไม่น้อยกว่า 10 ตัวอักษร")
                          ]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_formKey1.currentState.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              _formKey1.currentState.save();
                              _addPhone(_formKey1.currentState.value);
                            } else {}
                          },
                          child: Container(
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
                            child: isLoading == true
                                ? Center(child: CircularProgressIndicator())
                                : Text(
                                    "ยืนยัน",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
