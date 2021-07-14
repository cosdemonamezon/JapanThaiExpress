
import 'dart:ui';

import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  ContactUs({Key key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  List<dynamic> help = [];
  bool isLoading = true;
  SharedPreferences prefs;
  int totalResults = 0;
  int page = 1;
  int pageSize = 10;

  @override
  void initState() {
    super.initState();
    _helpCenter();
  }

  _helpCenter() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var url = Uri.parse(pathAPI +
        'api/app/contact_page?status=&page=$page&page_size=$pageSize');
    var response = await http.get(url, headers: {
      //'Content-Type': 'application/json',
      'Authorization': token['data']['token']
    });
    if (response.statusCode == 200) {
      final Map<String, dynamic> helpdata = convert.jsonDecode(response.body);
      print(helpdata['message']);
      if (helpdata['code'] == 200) {
        setState(() {
          totalResults = helpdata['data']['total'];
          help.addAll(helpdata['data']['data']);
          //help = helpdata['data'];
          isLoading = false;
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
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("ช่องทางการติดต่อ"),
          leading: IconButton(
              onPressed: () {
                MyNavigator.goToProfileScreen(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_rounded,
              )),
        ),
        body: Container(
          height: height,
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: isLoading == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    // Container(
                    //   child: ListView.builder(
                    //       shrinkWrap: true,
                    //       itemCount: help.length,
                    //       itemBuilder: (BuildContext context, int index) {
                    //         return Padding(
                    //           padding: EdgeInsets.symmetric(
                    //               vertical: 5.0, horizontal: 5.0),
                    //           child: helpCard(
                    //             help[index]['title'],
                    //             help[index]['icon'],
                    //             help[index]['link'],
                    //           ),
                    //         );
                    //       }),
                    // ),
                    /*Center(
                        child: Text(
                      'กดคลิกเพื่อ เลือกช่องทางติดต่อ',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    )),*/
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: GridView.builder(
                          itemCount: help.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (BuildContext context, int index) {
                            return dashboardItem(
                              Icons.local_atm_outlined,
                              4,
                              context,
                              help[index]['link'],
                              help[index]['title'],
                              help[index]['icon'],
                            );
                          }),
                    ),
                  ],
                ),
        )
        //bottomNavigationBar: NavigationBar(),
        );
  }

  Card dashboardItem(
    IconData icon,
    int page,
    context,
    String _url,
    String title,
    String subtitle,
  ) {
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
            _launchURL(_url);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            verticalDirection: VerticalDirection.down,
            children: [
              SizedBox(height: 10.0),
              Center(
               
                child: Image.network(
                  
                  subtitle,
                  
                  color: Color(0xFFd73925),
                  width: 80,
                ),
              ),
              SizedBox(height: 5.0),
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

  Container helpCard(String title, String subtitle, String _url) {
    return Container(
      //height: 100,
      decoration: BoxDecoration(
        color: Color(0xFFF5F6F9),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          _launchURL(_url);
        },
        child: ListTile(
          leading: Image.network(subtitle),
          title: Text(
            title,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
}
