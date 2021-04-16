import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/japanexpress.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';

class PreoderScreen extends StatefulWidget {
  PreoderScreen({Key key}) : super(key: key);

  @override
  _PreoderScreenState createState() => _PreoderScreenState();
}

class _PreoderScreenState extends State<PreoderScreen> {
  SharedPreferences prefs;
  SharedPreferences prefsNoti;
  bool isLoading = false;
  Map<String, dynamic> data = {};
  List<dynamic> notidata = [];
  Map<String, dynamic> readnotidata = {};
  Map<String, dynamic> numberNoti = {};

  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getList();
  }

  _readNotiMember() {}

  _getList() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      isLoading = true;
    });
    var url = pathAPI + 'api/preorders';
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token['data']['token']
      },
    );
    if (response.statusCode == 200) {
      //print(response.statusCode);
      final Map<String, dynamic> notinumber = convert.jsonDecode(response.body);
      //print(notinumber);
      if (notinumber['code'] == 200) {
        setState(() {
          notidata = notinumber['data']['data'];
          setState(() {
            isLoading = false;
          });
        });

        //print(notidata.length);
      } else {
        String title = "ข้อผิดพลาดภายในเซิร์ฟเวอร์";
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => dialogDenied(
            title,
            picDenied,
            context,
          ),
        );
      }
    } else {
      final Map<String, dynamic> notinumber = convert.jsonDecode(response.body);

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialogDenied(
          notinumber['massage'],
          picDenied,
          context,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text("PreOrders"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, true);
              }),
          bottom: TabBar(
              labelColor: Colors.redAccent,
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.white),
              tabs: [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("New Orders"),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("History"),
                  ),
                ),
              ]),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              // width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      controller: editingController,
                      decoration: InputDecoration(
                          labelText: "Search",
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)))),
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: notidata.length,
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              color: notidata[index]["noti_log_read"] == 0
                                  ? Colors.blue[50]
                                  : Colors.white,
                              elevation: 4.0,
                              child: Container(
                                decoration: BoxDecoration(color: Colors.white),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  leading: Container(
                                    padding: EdgeInsets.only(right: 14.0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            right: BorderSide(
                                                width: 2.0,
                                                color: primaryColor))),
                                    child:
                                        Image.network(notidata[index]['image']),
                                  ),
                                  title: Text(
                                    notidata[index]['name'],
                                    style: TextStyle(
                                        color: kTextButtonColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Row(
                                    children: <Widget>[
                                      Flexible(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                            RichText(
                                              text: TextSpan(
                                                text: "Qty :" +
                                                    notidata[index]['qty'],
                                                style: TextStyle(
                                                    color: kTextButtonColor),
                                              ),
                                              maxLines: 3,
                                              softWrap: true,
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: "Create At :" +
                                                    notidata[index]
                                                            ['created_at']
                                                        .split("T")[0],
                                                style: TextStyle(
                                                    color: kTextButtonColor),
                                              ),
                                              maxLines: 3,
                                              softWrap: true,
                                            ),
                                          ]))
                                    ],
                                  ),
                                  trailing: MaterialButton(
                                    onPressed: () {
                                      MyNavigator.goToTimelineOrders(context);
                                    },
                                    color: Color(0xffdd4b39),
                                    child: Text(
                                      "Details",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  onTap: () {},
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
            Icon(Icons.movie),
          ],
        ),
        bottomNavigationBar: Navigation(),
      ),
    );
  }

  Card buildCard(String title, String image) {
    return Card(
      child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(image),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MaterialButton(
                onPressed: () {
                  MyNavigator.goToTimelineOrders(context);
                },
                color: Color(0xffdd4b39),
                child: Text(
                  "Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

Card messageCard(String title, IconData icon, String subtitle) {
  return Card(
    child: ListTile(
      leading: Icon(
        icon,
        color: Colors.blue,
        size: 40.0,
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
      subtitle: Text(subtitle),
    ),
  );
}
