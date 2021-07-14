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
import 'package:JapanThaiExpress/AdminScreens/Exchange/ExchangeDetailScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class ExchangeScreen extends StatefulWidget {
  ExchangeScreen({Key key}) : super(key: key);

  @override
  _ExchangeScreenState createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> {
  List<bool> checked = [false, true, false, false, true];
  String valueChoose;
  bool isLoading = false;
  Io.File _image;
  String img64;
  String _transport;
  String costth;
  final picker = ImagePicker();
  String dataName;
  List dropdownValue = [];
  List dropdownShip = [];
  List dataValue = [];
  List address = [];
  int id;
  String name;
  String add;
  String tel;
  int _value = 1;
  final _formKey = GlobalKey<FormBuilderState>();
  final _formKey1 = GlobalKey<FormBuilderState>();
  SharedPreferences prefs;
  String tokendata = "";
  List<dynamic> ExchangeScreendata = []; //ประกาศตัวแปร อาร์เรย์ ไว้
  int totalResults = 0;
  int page = 1;
  int pageSize = 10;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  //String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJsdW1lbi1qd3QiLCJzdWIiOjYsImlhdCI6MTYxNTcxNTA3NCwiZXhwIjoxNjE1ODAxNDc0fQ.qX0GNbwo7PNY8TD4AXYQwGywdrOVmolOYum9wg1sG84";

  @override
  void initState() {
    super.initState();
    _getExchangeScreenory();
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    //ทุกครั้งที่รีเฟรชจะเคียร์อาร์เรย์และ set page เป็น 1
    _getExchangeScreenory(); //ทุกครั้งที่ทำการรีเฟรช จะดึงข้อมูลใหม่
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    //ทุกครั้งที่รีเฟรชจะเคียร์อาร์เรย์และ set page เป็น 1
    _getExchangeScreenory(); //ทุกครั้งที่ทำการรีเฟรช จะดึงข้อมูลใหม่
    _refreshController.refreshCompleted();
  }

  _getExchangeScreenory() async {
    try {
      setState(() {
        page == 1 ? isLoading = true : isLoading = false;
      });
      prefs = await SharedPreferences.getInstance();
      var tokenString = prefs.getString('token');
      var token = convert.jsonDecode(tokenString);
      var url = Uri.parse(
          pathAPI + 'api/get_exchange?status=&page=$page&page_size=$pageSize');
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
          ExchangeScreendata.clear();
          ExchangeScreendata.addAll(depdata['data']['data']);
          isLoading = false;
          // print(depdata['message']);
          // print(totalResults);
          // print("test");
          // print(ExchangeScreendata.length);
          // print(ExchangeScreendata[1]['description']);
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
              title: Text("รายการฝากโอน"),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
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
                        child: Text("รายการใหม่"),
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("ประวัติ"),
                      ),
                    ),
                  ])),
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
                        child: ExchangeScreendata.length > 0
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: ExchangeScreendata.length,
                                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                itemBuilder: (BuildContext context, int index) {
                                  return ExchangeScreendata[index]['status'] ==
                                          'new'
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: GestureDetector(
                                            onTap: () {
                                              var arg = {
                                                "id": ExchangeScreendata[index]
                                                    ['id'],
                                              };
                                              MyNavigator.goToExchangeDetail(
                                                  context, arg);
                                            },
                                            child: Card(
                                              color: Colors.white,
                                              elevation: 4.0,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white),
                                                child: ListTile(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20.0,
                                                            vertical: 10.0),
                                                    leading: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 14.0),
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                right: BorderSide(
                                                                    width: 2.0,
                                                                    color:
                                                                        primaryColor))),
                                                        child: Icon(
                                                          Icons.money,
                                                        )),
                                                    title: Text(
                                                      'เลขที่ :' +
                                                          ExchangeScreendata[
                                                              index]['code'],
                                                      style: TextStyle(
                                                          color:
                                                              kTextButtonColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    subtitle: Row(
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
                                                                  text: "เรทค่าเงิน :" +
                                                                      ExchangeScreendata[
                                                                              index]
                                                                          [
                                                                          'rate'],
                                                                  style: TextStyle(
                                                                      color:
                                                                          kTextButtonColor),
                                                                ),
                                                                maxLines: 3,
                                                                softWrap: true,
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text: "Fee :" +
                                                                      ExchangeScreendata[
                                                                              index]
                                                                          [
                                                                          'fee'],
                                                                  style: TextStyle(
                                                                      color:
                                                                          kTextButtonColor),
                                                                ),
                                                                maxLines: 3,
                                                                softWrap: true,
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text: "คอมมิชชั่น :" +
                                                                      ExchangeScreendata[
                                                                              index]
                                                                          [
                                                                          'com'],
                                                                  style: TextStyle(
                                                                      color:
                                                                          kTextButtonColor),
                                                                ),
                                                                maxLines: 3,
                                                                softWrap: true,
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text: "ยอดรวม :" +
                                                                      ExchangeScreendata[
                                                                              index]
                                                                          [
                                                                          'total'],
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
                                                                      ExchangeScreendata[index]
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
                                                    trailing: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        IconButton(
                                                          icon: const Icon(Icons
                                                              .keyboard_arrow_right_outlined),
                                                          color: Colors
                                                              .orange[900],
                                                          iconSize: 30,
                                                          onPressed: () {},
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 0,
                                        );
                                })
                            : Center(child: Text('ไม่พบข้อมูล'))),
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
                        child: ExchangeScreendata.length > 0
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: ExchangeScreendata.length,
                                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                itemBuilder: (BuildContext context, int index) {
                                  return ExchangeScreendata[index]['status'] !=
                                          'new'
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: GestureDetector(
                                            onTap: () {
                                              var arg = {
                                                "id": ExchangeScreendata[index]
                                                    ['id'],
                                              };
                                              MyNavigator.goToExchangeDetail(
                                                  context, arg);
                                            },
                                            child: Card(
                                              color: Colors.white,
                                              elevation: 4.0,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white),
                                                child: ListTile(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20.0,
                                                            vertical: 10.0),
                                                    leading: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 14.0),
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                right: BorderSide(
                                                                    width: 2.0,
                                                                    color:
                                                                        primaryColor))),
                                                        child: Icon(
                                                          Icons.money,
                                                        )),
                                                    title: Text(
                                                      'เลขที่ :' +
                                                          ExchangeScreendata[
                                                              index]['code'],
                                                      style: TextStyle(
                                                          color:
                                                              kTextButtonColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    subtitle: Row(
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
                                                                  text: "เรทค่าเงิน :" +
                                                                      ExchangeScreendata[
                                                                              index]
                                                                          [
                                                                          'rate'],
                                                                  style: TextStyle(
                                                                      color:
                                                                          kTextButtonColor),
                                                                ),
                                                                maxLines: 3,
                                                                softWrap: true,
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text: "Fee :" +
                                                                      ExchangeScreendata[
                                                                              index]
                                                                          [
                                                                          'fee'],
                                                                  style: TextStyle(
                                                                      color:
                                                                          kTextButtonColor),
                                                                ),
                                                                maxLines: 3,
                                                                softWrap: true,
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text: "คอมมิชชั่น :" +
                                                                      ExchangeScreendata[
                                                                              index]
                                                                          [
                                                                          'com'],
                                                                  style: TextStyle(
                                                                      color:
                                                                          kTextButtonColor),
                                                                ),
                                                                maxLines: 3,
                                                                softWrap: true,
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text: "ยอดรวม :" +
                                                                      ExchangeScreendata[
                                                                              index]
                                                                          [
                                                                          'total'],
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
                                                                      ExchangeScreendata[index]
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
                                                    trailing: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        IconButton(
                                                          icon: const Icon(Icons
                                                              .keyboard_arrow_right_outlined),
                                                          color: Colors
                                                              .orange[900],
                                                          iconSize: 30,
                                                          onPressed: () {},
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 0,
                                        );
                                })
                            : Center(child: Text('ไม่พบข้อมูล'))),
              ),
            ],
          ),
          bottomNavigationBar: Navigation(),
        ));
  }

  selectdialog(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 1,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(
            left: Constants.padding,
            top: Constants.avatarRadius - Constants.padding,
            right: Constants.padding,
            bottom: Constants.padding),
        margin: EdgeInsets.only(top: Constants.avatarRadius),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: kFontPrimaryColor,
            borderRadius: BorderRadius.circular(Constants.padding),
            boxShadow: [
              BoxShadow(
                  color: Colors.black, offset: Offset(0, 2), blurRadius: 2),
            ]),
      ),
    );
  }
}
