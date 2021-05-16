//import 'package:JapanThaiExpress/UserScreens/Wallet/Topup.dart';
import 'package:JapanThaiExpress/UserScreens/Wallet/WalletDetail.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class WalletScreen extends StatefulWidget {
  WalletScreen({Key key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  List<Color> _backgroundColor;
  Color _iconColor;
  Color _textColor;
  List<Color> _actionContainerColor;
  Color _borderContainer;
  bool colorSwitched = false;
  var logoImage;
  SharedPreferences prefs;
  String wallet = "....";
  Map<String, dynamic> datawallet;
  bool isLoading = true;
  int totalResults = 0;
  int page = 1;
  int pageSize = 10;
  List<dynamic> walletdata = [];

  @override
  void initState() {
    super.initState();
    _getWallet();
    _transaction();
  }

  _getWallet() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    //print(token['data']['wallet']);
    var url = Uri.parse(pathAPI + 'api/get_member');
    var response = await http.get(
      url,
      headers: {
        //'Content-Type': 'application/json',
        'Authorization': token['data']['token']
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> wallettdata =
          convert.jsonDecode(response.body);
      setState(() {
        datawallet = wallettdata['data'];
        wallet = datawallet['wallet'];
        isLoading = false;
      });
    } else {
      var feedback = convert.jsonDecode(response.body);
      print("${feedback['message']}");
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

    // setState(() {
    //   wallet = token['data']['wallet'];
    // });
  }

  _transaction() async {
    try {
      setState(() {
        page == 1 ? isLoading = true : isLoading = false;
      });
      prefs = await SharedPreferences.getInstance();
      var tokenString = prefs.getString('token');
      var token = convert.jsonDecode(tokenString);
      var url = Uri.parse(pathAPI +
          'api/app/transaction_page?page=$page&page_size=$pageSize');
      var response = await http.get(
        url,
        headers: {
          //'Content-Type': 'application/json',
          'Authorization': token['data']['token']
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> depdata = convert.jsonDecode(response.body);
        setState(() {
            totalResults = depdata['data']['total'];
            walletdata.addAll(depdata['data']['data']);
            isLoading = false;
            print(walletdata[0]['payment_type']);
            // print(totalResults);
            // print("test");
            // print(depositdata.length);
            // print(depositdata[1]['description']);
          });
        
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
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("กระเป๋าสตางค์"),
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
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/images/cat-wallet.png'),
                        ))),
                    SizedBox(height: 10),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "ยอดเงินคงเหลือ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                //"0.00 ฿",
                                '${wallet}' + ' ฿',
                                style: TextStyle(
                                    color: Color(0xffdd4b39),
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              /* Text(
                                "ชื่อ-นามสกุล",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),*/
                              SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  MyNavigator.goToChooseService(context);
                                },
                                child: Container(
                                  width: 100,
                                  padding: EdgeInsets.symmetric(vertical: 5),
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
                                  child: Text(
                                    "เติมเงิน",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                Text(
                  "ประวัติการทำรายการ",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 400,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: walletdata.length,
                            itemBuilder: (BuildContext context, int index) {
                              return buildCard(
                                'assets/images/cat-wallet.png',
                                'ช่องทาง: ${walletdata[index]['payment_type']}',
                                'วันที่: ${walletdata[index]['created_at']}',
                                'ยอดเงิน: ${walletdata[index]['amount']}',
                                'สถานะ: ${walletdata[index]['status']}',
                              );
                            }),
                      ],
                    ),
                  ),
                ),
                //buildCard('assets/images/cat-wallet.png','ช่องทาง:','วันที่:','เวลา:','สถานะ:',)
                /* Container(
                  padding: EdgeInsets.all(190),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color(0xfff1f3f6),
                  ),
                ),*/

                /*ListView(
                    children: [
                      Card(
                        color: Colors.orange[50],
                        child: ListTile(
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [],
                          ),
                          subtitle: Text("..."),
                          trailing: IconButton(
                              icon: Icon(
                                Icons.edit,
                                size: 25,
                              ),
                              onPressed: () {}),
                        ),
                      ),
                    ],
                  ),*/
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(),
    );
  }

  Card buildCard(
    String img,
    String title,
    String title2,
    String title3,
    String title4,
  ) {
    return Card(
      //color: Color(0xfff1f3f6),
      child: ListTile(
        leading: Container(
            width: 90,
            height: 150,
            child: Image.asset(
              img,
              fit: BoxFit.fitHeight,
            )),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            Text(
              title2,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            Text(
              title3,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            Text(
              title4,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
