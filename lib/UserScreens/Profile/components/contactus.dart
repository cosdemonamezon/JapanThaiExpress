import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

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
        'api/app/help_center_page?status=&page=$page&page_size=$pageSize');
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
    body:Container(
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
                  Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: help.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 5.0),
                            child: helpCard(
                              help[index]['title'],
                              help[index]['description'],
                            ),
                          );
                        }),
                  ),
                ],
              ),
     )
      //bottomNavigationBar: NavigationBar(),
    );
  }


  Container helpCard(String title, String subtitle) {
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
         
        },
        child: ListTile(
          leading: Image.network('https://i.pinimg.com/originals/61/9e/6b/619e6bbe255cda842f0a7ee2adcb7ca0.png'),
          title: Text(
            title,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}