import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/japanexpress.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../utils/my_navigator.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  SharedPreferences prefs;
  SharedPreferences prefsNoti;
  bool isLoading = false;
  Map<String, dynamic> data = {};
  List<dynamic> notidata = [];
  Map<String, dynamic> readnotidata = {};
  Map<String, dynamic> numberNoti = {};

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getList();
  }

  _readNotiMember() {}

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    //ทุกครั้งที่รีเฟรชจะเคียร์อาร์เรย์และ set page เป็น 1
    _getList(); //ทุกครั้งที่ทำการรีเฟรช จะดึงข้อมูลใหม่
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    //ทุกครั้งที่รีเฟรชจะเคียร์อาร์เรย์และ set page เป็น 1
    _getList(); //ทุกครั้งที่ทำการรีเฟรช จะดึงข้อมูลใหม่
    _refreshController.refreshCompleted();
  }

  _getList() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(pathAPI + 'api/get_noti_admin');
    var response = await http.get(
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
          notidata = notinumber['data'];
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              MyNavigator.goToAdmin(context);
            }),
        centerTitle: true,
        title: Text("แจ้งเตือน"),
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : notidata.length == 0
              ? Center(
                  child: Text(
                    "ไม่พบข้อมูล",
                    style: TextStyle(
                      fontSize: 30,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Container(
                  width: double.infinity,
                  child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: ClassicHeader(
                      refreshStyle: RefreshStyle.Follow,
                      refreshingText: 'กำลังโหลด.....',
                      completeText: 'โหลดข้อมูลสำเร็จ',
                    ),
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          //body =  Text("ไม่พบรายการ");
                        } else if (mode == LoadStatus.loading) {
                          body = CircularProgressIndicator();
                        } else if (mode == LoadStatus.failed) {
                          body = Text("Load Failed!Click retry!");
                        } else if (mode == LoadStatus.canLoading) {
                          body = Text("release to load more");
                        } else if (mode == LoadStatus.noMore) {
                          //body = Text("No more Data");
                          body = Text("ไม่พบข้อมูล");
                        }
                        return Container(
                          height: 55.0,
                          child: Center(child: body),
                        );
                      },
                    ),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: notidata.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GestureDetector(
                              onTap: () {
                                var arg = {
                                  "id": notidata[index]['id'].toString(),
                                  "title": notidata[index]['title'].toString(),
                                  "description":
                                      notidata[index]['description'].toString(),
                                  "type": notidata[index]['type'].toString(),
                                  "created_at":
                                      notidata[index]['created_at'].toString()
                                };
                                MyNavigator.goToNotiDetail(context, arg);
                              },
                              child: Card(
                                color: notidata[index]["noti_log_read"] == 0
                                    ? Colors.blue[50]
                                    : Colors.white,
                                elevation: 8.0,
                                child: ListTile(
                                  leading: notidata[index]["pic"] == null
                                      ? Icon(
                                          Icons.notifications_active,
                                          size: 40,
                                          color: kPrimaryColor,
                                        )
                                      : Container(
                                          width: 70.0,
                                          height: 50.0,
                                          child: Image.network(
                                            notidata[index]['pic'],
                                            fit: BoxFit.fill,
                                          )),
                                  title: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: notidata[index]['title'].length >= 30
                                        ? Text(
                                            "${notidata[index]['title'].substring(0, 30)} ...",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400))
                                        : Text(notidata[index]['title'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400)),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: notidata[index]['description']
                                                .length >=
                                            50
                                        ? Text(
                                            "${notidata[index]['description'].substring(0, 50)} ...",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400))
                                        : Text(
                                            notidata[index]['description'] +
                                                '\n' +
                                                'วันที่ ' +
                                                notidata[index]['created_at'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400)),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
      bottomNavigationBar: Navigation(),
    );
  }

  Card messageCard(String title, IconData icon, String subtitle) {
    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: Color(0xffdd4b39),
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
}
