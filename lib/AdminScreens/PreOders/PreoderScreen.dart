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
          title: Text("Service Orders"),
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
            // Container(
            //   child: ListView(
            //     shrinkWrap: true,
            //     padding: EdgeInsets.only(left: 15.0, right: 15.0),
            //     children: [
            //       SizedBox(
            //         height: 15,
            //       ),
            //       //messageCard("Learn Git and GitHub without any code!", Icons.account_box, "Software developer"),
            //       buildCard(
            //         "100/17.フマキラー スキンベープ 虫よけスプレー ミストタイプ キティ ピーチの香り(200ml) 185.00 บาท",
            //         "assets/o1.jpg",
            //       ),
            //       buildCard(
            //         "50/13.口内炎パッチ大正A 10枚 220.00 บาท",
            //         "assets/o2.jpg",
            //       ),
            //       buildCard(
            //         "50/16.資生堂フィーノ プレミアムタッチ 浸透美容液ヘアマスク 230g 270.00 บาท",
            //         "assets/o3.jpg",
            //       ),
            //       buildCard(
            //         "50/68.Blueクリニカ アドバンテージ ハミガキ クールミン 115.00 บาท",
            //         "assets/o4.jpg",
            //       ),
            //       buildCard(
            //         "50/12.ニューアンメルツヨコヨコA 80mL 180.00 บาท",
            //         "assets/o5.jpg",
            //       ),
            //       buildCard(
            //         "50/29.ウーノ ホイップウォッシュ モイスト 125.00 บาท",
            //         "assets/o6.jpg",
            //       ),
            //       buildCard(
            //         "50/6.DHC コラーゲン 60日分 360粒 345.00 บาท",
            //         "assets/o7.jpg",
            //       ),
            //       buildCard(
            //         "50/25.ペアA錠 120錠 225.00 บาท",
            //         "assets/o8.jpg",
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              width: double.infinity,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: notidata.length,
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                        onTap: () {},
                        child: Card(
                          color: notidata[index]["noti_log_read"] == 0
                              ? Colors.blue[50]
                              : Colors.white,
                          elevation: 8.0,
                          child: ListTile(
                            leading: notidata[index]["image"] == null
                                ? Icon(
                                    Icons.notifications_active,
                                    size: 40,
                                    color: kPrimaryColor,
                                  )
                                : Container(
                                    width: 70.0,
                                    height: 50.0,
                                    child: Image.network(
                                      notidata[index]['image'],
                                      fit: BoxFit.fill,
                                    )),
                            title: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: notidata[index]['name'].length >= 30
                                  ? Text(
                                      "${notidata[index]['name'].substring(0, 30)} ...",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400))
                                  : Text(notidata[index]['name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400)),
                            ),
                            // subtitle: Padding(
                            //   padding: const EdgeInsets.all(5.0),
                            //   child: notidata[index]['note'].length >= 50
                            //       ? Text(
                            //           "${notidata[index]['note'].substring(0, 50)} ...",
                            //           style: TextStyle(
                            //               fontWeight: FontWeight.w400))
                            //       : Text(notidata[index]['note'],
                            //           style: TextStyle(
                            //               fontWeight: FontWeight.w400)),
                            // ),
                            subtitle: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
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
                          ),
                        ),
                      ),
                    );
                  }),
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
