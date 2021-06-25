import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = true;
  List<dynamic> noti = [];
  String tokendata = "";
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _getNotiuser();
  }

  _getNotiuser() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      //isLoading = false;
      tokendata = token['data']['token'];
    });
    var url = Uri.parse(pathAPI + 'api/get_noti_user');
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': token['data']['token']
    });
    if (response.statusCode == 200) {
      final Map<String, dynamic> notidata = convert.jsonDecode(response.body);
      if (notidata['code'] == 200) {
        setState(() {
          isLoading = false;
          noti = notidata['data'];
        });
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
        //centerTitle: true,
        title: Text("การแจ้งเตือน"),
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
        padding: EdgeInsets.symmetric(horizontal: 15),
        color: Colors.grey[200],
        child: isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: noti.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
                    child: messageCard(
                      noti[index]['title'],
                      "assets/icons/Megaphone.svg",
                      noti[index]['description'],
                      noti[index]['type'],
                      noti[index]['created_at'],
                    ),
                  );
                }),
      ),
      bottomNavigationBar: NavigationBar(),
    );
  }

  Card messageCard(String title, String img, String subtitle, String type,
      String created_at) {
    return Card(
      color: kFontPrimaryColor,
      child: GestureDetector(
        onTap: () {
          var arg = {
            "title": title,
            "description": subtitle,
            "type": type,
            "created_at": created_at,
          };
          MyNavigator.goToNotiDetailUser(context, arg);
        },
        child: ListTile(
          leading: Container(
            child: SvgPicture.asset(
              img,
              height: 33,
              width: 30,
              fit: BoxFit.fill,
              color: kCicleColor,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: kTextButtonColor),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: kTextButtonColor),
          ),
        ),
      ),
    );
  }
}
