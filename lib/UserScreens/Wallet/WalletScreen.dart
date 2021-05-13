//import 'package:JapanThaiExpress/UserScreens/Wallet/Topup.dart';
import 'package:JapanThaiExpress/UserScreens/Wallet/WalletDetail.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
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

  @override
  void initState() {
    super.initState();
    _getWallet();
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
    } else {}

    // setState(() {
    //   wallet = token['data']['wallet'];
    // });
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
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/images/cat-wallet.png'),
                        ))),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color(0xfff1f3f6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ยอดเงินคงเหลือ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                //"0.00 ฿",
                                '${wallet}'+' ฿',
                                style: TextStyle(
                                    color: Color(0xffdd4b39),
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "ชื่อ-นามสกุล : "+'${datawallet['fname_th']} '+' ${datawallet['lname_th']}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffdd4b39)),
                            child: Icon(
                              
                              Icons.add,
                              color: Color(0xfff1f3f6),
                              size: 30,
                            ),
                          )
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
                SizedBox(height: 5),
                 buildCard('assets/images/cat-wallet.png','เติมเงิน','ช่องทาง:','วันที่:','...',)
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
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Text(
                title2,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
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
