import 'package:JapanThaiExpress/UserScreens/Wallet/Topup.dart';
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

  void changeTheme() async {
    if (colorSwitched) {
      setState(() {
        logoImage = 'assets/images/wallet_dark_logo.png';
        _backgroundColor = [
          Color.fromRGBO(252, 214, 0, 1),
          Color.fromRGBO(251, 207, 6, 1),
          Color.fromRGBO(250, 197, 16, 1),
          Color.fromRGBO(249, 161, 28, 1),
        ];
        _iconColor = Colors.white;
        _textColor = Color.fromRGBO(253, 211, 4, 1);
        _borderContainer = Color.fromRGBO(34, 58, 90, 0.2);
        _actionContainerColor = [
          Color.fromRGBO(47, 75, 110, 1),
          Color.fromRGBO(43, 71, 105, 1),
          Color.fromRGBO(39, 64, 97, 1),
          Color.fromRGBO(34, 58, 90, 1),
        ];
      });
    } else {
      setState(() {
        logoImage = 'assets/images/wallet_logo.png';
        _borderContainer = Color.fromRGBO(252, 233, 187, 1);
        _backgroundColor = [
          Color.fromRGBO(249, 249, 249, 1),
          Color.fromRGBO(241, 241, 241, 1),
          Color.fromRGBO(233, 233, 233, 1),
          Color.fromRGBO(222, 222, 222, 1),
        ];
        _iconColor = Colors.black;
        _textColor = Colors.black;
        _actionContainerColor = [
          Color.fromRGBO(255, 212, 61, 1),
          Color.fromRGBO(255, 212, 55, 1),
          Color.fromRGBO(255, 211, 48, 1),
          Color.fromRGBO(255, 211, 43, 1),
        ];
      });
    }
  }

  @override
  void initState() {
    changeTheme();
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
      final Map<String, dynamic> wallettdata = convert.jsonDecode(response.body);
      setState(() {
        datawallet = wallettdata['data'];
        wallet = datawallet['wallet'];
        isLoading = false;
      });
    } else {
    }

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
        title: Text("Wallet"),
        leading: IconButton(
            onPressed: () {
              MyNavigator.goBackUserHome(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            )),
      ),
      body: SafeArea(
        child: GestureDetector(
          onLongPress: () {
            if (colorSwitched) {
              colorSwitched = false;
            } else {
              colorSwitched = true;
            }
            changeTheme();
          },
          child: isLoading == true ?
          Center(
            child: CircularProgressIndicator(),
          )
          :Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [0.2, 0.3, 0.5, 0.8],
                    colors: _backgroundColor)),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  height: 5.0,
                ),
                Image.asset(
                  logoImage,
                  fit: BoxFit.contain,
                  height: 100.0,
                  width: 100.0,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'Hello',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    Text(
                      '${datawallet['fname_th']} '+' ${datawallet['lname_th']}',
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Container(
                  height: 400.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: _borderContainer,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              stops: [0.2, 0.4, 0.6, 0.8],
                              colors: _actionContainerColor)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 70,
                            child: Center(
                              child: ListView(
                                children: <Widget>[
                                  Text(
                                    '${wallet}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: _textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30),
                                  ),
                                  Text(
                                    'ยอดเงินคงเหลือ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: _iconColor, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: 0.5,
                            color: Colors.grey,
                          ),
                          Table(
                            border: TableBorder.symmetric(
                              inside: BorderSide(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 0.5),
                            ),
                            children: [
                              TableRow(children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WalletDetail()));
                                  },
                                  child: _actionList(
                                      'assets/images/ic_send.png',
                                      'Send Money'),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    MyNavigator.goToChooseService(context);
                                  },
                                  child: _actionList(
                                      'assets/images/ic_money.png', 'เติมเงิน'),
                                ),
                              ]),
                              TableRow(children: [
                                GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context, MaterialPageRoute(builder: (context) => WalletDetail())
                                    // );
                                  },
                                  child: _actionList(
                                      'assets/images/ic_transact.png',
                                      'Transactions'),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context, MaterialPageRoute(builder: (context) => WalletDetail())
                                    // );
                                  },
                                  child: _actionList(
                                      'assets/images/ic_reward.png',
                                      'Reward Points'),
                                ),
                              ])
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(),
    );
  }

  // custom action widget
  Widget _actionList(String iconPath, String desc) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            iconPath,
            fit: BoxFit.contain,
            height: 45.0,
            width: 45.0,
            color: _iconColor,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            desc,
            style: TextStyle(color: _iconColor),
          )
        ],
      ),
    );
  }
}
