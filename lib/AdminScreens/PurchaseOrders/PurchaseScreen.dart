import 'dart:io' as Io;
import 'dart:convert';
import 'package:JapanThaiExpress/UserScreens/Service/DetailStep.dart';
import 'package:JapanThaiExpress/UserScreens/Service/Service.dart';
import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:JapanThaiExpress/alert.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class PurchaseScreen extends StatefulWidget {
  PurchaseScreen({Key key}) : super(key: key);

  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  SharedPreferences prefs;
  SharedPreferences prefsNoti;
  bool isLoading = false;
  Map<String, dynamic> data = {};
  List<dynamic> notidata = [];
  Map<String, dynamic> readnotidata = {};
  Map<String, dynamic> numberNoti = {};
  List<dynamic> PurchaseScreen = [];
  TextEditingController editingController = TextEditingController();

  int totalResults = 0;
  int page = 1;
  int pageSize = 10;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPrechaseScreen();
  }

  _readNotiMember() {}

  _getPrechaseScreen() async {
    try {
      setState(() {
        page == 1 ? isLoading = true : isLoading = false;
      });
      prefs = await SharedPreferences.getInstance();
      var tokenString = prefs.getString('token');
      var token = convert.jsonDecode(tokenString);
      var url = Uri.parse(pathAPI +
          'api/app/order_list?status=&page=$page&page_size=$pageSize');
      var response = await http.get(
        url,
        headers: {
          //'Content-Type': 'application/json',
          'Authorization': token['data']['token']
        },
        // body: ({
        //   'status': '',
        //   'page': page.toString(),
        //   'page_size': pageSize.toString(),
        // })
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> depdata = convert.jsonDecode(response.body);
        setState(() {
          totalResults = depdata['data']['total'];
          PurchaseScreen.addAll(depdata['data']['data']);
          isLoading = false;
          // print(depdata['message']);
          // print(totalResults);
          // print("test");
          // print(PreoderScreendata.length);
          // print(PreoderScreendata[1]['description']);
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('error from backend ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    //ทุกครั้งที่รีเฟรชจะเคียร์อาร์เรย์และ set page เป็น 1
    setState(() {
      PurchaseScreen.clear();
      page = 1;
    });
    _getPrechaseScreen(); //ทุกครั้งที่ทำการรีเฟรช จะดึงข้อมูลใหม่
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    //items.add((items.length+1).toString());
    if (page < (totalResults / pageSize).ceil()) {
      if (mounted) {
        print("mounted");
        setState(() {
          page = ++page;
        });
        _getPrechaseScreen();
        _refreshController.loadComplete();
      } else {
        print("unmounted");
        _refreshController.loadComplete();
      }
    } else {
      _refreshController.loadNoData();
      _refreshController.resetNoData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text("รายการสินค้า"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                MyNavigator.goToAdmin(context);
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
                    child: Text("รายการใหม่"),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("ประวัติ"),
                  ),
                ),
              ]),
        ),
        body: TabBarView(
          children: [
            Container(
              height: height,
              color: Colors.grey[300],
              child: isLoading == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SmartRefresher(
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
                            // body = Text("ไม่พบข้อมูล");
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
                      child: PurchaseScreen.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: PurchaseScreen.length,
                              padding: EdgeInsets.only(left: 5.0, right: 5.0),
                              itemBuilder: (BuildContext context, int index) {
                                return PurchaseScreen[index]['step'] !=
                                        'delivery'
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Card(
                                          color: Colors.white,
                                          elevation: 4.0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white),
                                            child: ListTile(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 10.0),
                                                leading: Container(
                                                  padding: EdgeInsets.only(
                                                      right: 4.0),
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          right: BorderSide(
                                                              width: 2.0,
                                                              color:
                                                                  primaryColor))),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      PurchaseScreen[index]
                                                                  ['image'] !=
                                                              null
                                                          ? launch(
                                                              PurchaseScreen[
                                                                      index]
                                                                  ['image'])
                                                          : SizedBox(
                                                              height: 0,
                                                            );
                                                    },
                                                    child: Image.network(
                                                      PurchaseScreen[index][
                                                                      'image'] !=
                                                                  null &&
                                                              PurchaseScreen[
                                                                          index]
                                                                      [
                                                                      'image'] !=
                                                                  ""
                                                          ? PurchaseScreen[
                                                              index]['image']
                                                          : 'https://picsum.photos/200/300',
                                                      width: 70,
                                                    ),
                                                  ),
                                                ),
                                                title: GestureDetector(
                                                  onTap: () {
                                                    var arg =
                                                        PurchaseScreen[index]
                                                            ['id'];
                                                    MyNavigator
                                                        .goToTimelinePurchase(
                                                            context, arg);
                                                  },
                                                  child: Text(
                                                    PurchaseScreen[index]
                                                        ['code'],
                                                    style: TextStyle(
                                                        color: kTextButtonColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                subtitle: GestureDetector(
                                                  onTap: () {
                                                    var arg =
                                                        PurchaseScreen[index]
                                                            ['id'];
                                                    MyNavigator
                                                        .goToTimelinePurchase(
                                                            context, arg);
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Flexible(
                                                          child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                            RichText(
                                                              text: TextSpan(
                                                                text: "สินค้า :" +
                                                                    PurchaseScreen[index]
                                                                            [
                                                                            'product_name']
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    color:
                                                                        kTextButtonColor),
                                                              ),
                                                              maxLines: 3,
                                                              softWrap: true,
                                                            ),
                                                            RichText(
                                                              text: TextSpan(
                                                                text: "ลูกค้า : " +
                                                                    PurchaseScreen[index]
                                                                            [
                                                                            'fullname']
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    color:
                                                                        kTextButtonColor),
                                                              ),
                                                              maxLines: 3,
                                                              softWrap: true,
                                                            ),
                                                            RichText(
                                                              text: TextSpan(
                                                                text: "ราคา :" +
                                                                    PurchaseScreen[index]
                                                                            [
                                                                            'price']
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    color:
                                                                        kTextButtonColor),
                                                              ),
                                                              maxLines: 3,
                                                              softWrap: true,
                                                            ),
                                                            RichText(
                                                              text: TextSpan(
                                                                text: "วันที่บันทึก :" +
                                                                    PurchaseScreen[index]
                                                                            [
                                                                            'created_at']
                                                                        .split(
                                                                            "T")[0],
                                                                style: TextStyle(
                                                                    color:
                                                                        kTextButtonColor),
                                                              ),
                                                              maxLines: 3,
                                                              softWrap: true,
                                                            ),
                                                          ]))
                                                    ],
                                                  ),
                                                ),
                                                trailing: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(Icons
                                                          .keyboard_arrow_right_outlined),
                                                      color: Colors.orange[900],
                                                      iconSize: 30,
                                                      onPressed: () {
                                                        var arg =
                                                            PurchaseScreen[
                                                                index]['id'];
                                                        MyNavigator
                                                            .goToTimelinePurchase(
                                                                context, arg);
                                                      },
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 0,
                                      );
                              })
                          : Center(child: Text('ไม่พบข้อมูล')),
                    ),
            ),

            //tab 2
            Container(
              height: height,
              color: Colors.grey[300],
              child: isLoading == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SmartRefresher(
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
                            // body = Text("ไม่พบข้อมูล");
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
                      child: PurchaseScreen.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: PurchaseScreen.length,
                              padding: EdgeInsets.only(left: 5.0, right: 5.0),
                              itemBuilder: (BuildContext context, int index) {
                                return PurchaseScreen[index]['step'] ==
                                        'delivery'
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Card(
                                          color: Colors.white,
                                          elevation: 4.0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white),
                                            child: ListTile(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 10.0),
                                                leading: Container(
                                                  padding: EdgeInsets.only(
                                                      right: 4.0),
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          right: BorderSide(
                                                              width: 2.0,
                                                              color:
                                                                  primaryColor))),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      PurchaseScreen[index]
                                                                  ['image'] !=
                                                              null
                                                          ? launch(
                                                              PurchaseScreen[
                                                                      index]
                                                                  ['image'])
                                                          : SizedBox(
                                                              height: 0,
                                                            );
                                                    },
                                                    child: Image.network(
                                                      PurchaseScreen[index][
                                                                      'image'] !=
                                                                  null &&
                                                              PurchaseScreen[
                                                                          index]
                                                                      [
                                                                      'image'] !=
                                                                  ""
                                                          ? PurchaseScreen[
                                                              index]['image']
                                                          : 'https://picsum.photos/200/300',
                                                      width: 70,
                                                    ),
                                                  ),
                                                ),
                                                title: GestureDetector(
                                                  onTap: () {
                                                    var arg =
                                                        PurchaseScreen[index]
                                                            ['id'];
                                                    MyNavigator
                                                        .goToTimelinePurchase(
                                                            context, arg);
                                                  },
                                                  child: Text(
                                                    PurchaseScreen[index]
                                                        ['code'],
                                                    style: TextStyle(
                                                        color: kTextButtonColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                subtitle: GestureDetector(
                                                  onTap: () {
                                                    var arg =
                                                        PurchaseScreen[index]
                                                            ['id'];
                                                    MyNavigator
                                                        .goToTimelinePurchase(
                                                            context, arg);
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Flexible(
                                                          child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                            RichText(
                                                              text: TextSpan(
                                                                text: "สินค้า :" +
                                                                    PurchaseScreen[index]
                                                                            [
                                                                            'product_name']
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    color:
                                                                        kTextButtonColor),
                                                              ),
                                                              maxLines: 3,
                                                              softWrap: true,
                                                            ),
                                                            RichText(
                                                              text: TextSpan(
                                                                text: "ลูกค้า : " +
                                                                    PurchaseScreen[index]
                                                                            [
                                                                            'fullname']
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    color:
                                                                        kTextButtonColor),
                                                              ),
                                                              maxLines: 3,
                                                              softWrap: true,
                                                            ),
                                                            RichText(
                                                              text: TextSpan(
                                                                text: "ราคา :" +
                                                                    PurchaseScreen[index]
                                                                            [
                                                                            'price']
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    color:
                                                                        kTextButtonColor),
                                                              ),
                                                              maxLines: 3,
                                                              softWrap: true,
                                                            ),
                                                            RichText(
                                                              text: TextSpan(
                                                                text: "วันที่บันทึก :" +
                                                                    PurchaseScreen[index]
                                                                            [
                                                                            'created_at']
                                                                        .split(
                                                                            "T")[0],
                                                                style: TextStyle(
                                                                    color:
                                                                        kTextButtonColor),
                                                              ),
                                                              maxLines: 3,
                                                              softWrap: true,
                                                            ),
                                                          ]))
                                                    ],
                                                  ),
                                                ),
                                                trailing: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(Icons
                                                          .keyboard_arrow_right_outlined),
                                                      color: Colors.orange[900],
                                                      iconSize: 30,
                                                      onPressed: () {
                                                        var arg =
                                                            PurchaseScreen[
                                                                index]['id'];
                                                        MyNavigator
                                                            .goToTimelinePurchase(
                                                                context, arg);
                                                      },
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 0,
                                      );
                              })
                          : Center(child: Text('ไม่พบข้อมูล')),
                    ),
            ),
          ],
        ),
        bottomNavigationBar: Navigation(),
      ),
    );
  }

  Card buildCard(String title, int index, String image) {
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
                  var arg = PurchaseScreen[index]['id'];
                  MyNavigator.goToTimelinePurchase(context, arg);
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
