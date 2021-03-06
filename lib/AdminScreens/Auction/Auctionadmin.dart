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
import 'package:JapanThaiExpress/AdminScreens/Auction/Auctionadmin.dart';
import 'package:url_launcher/url_launcher.dart';

class Auctionadmin extends StatefulWidget {
  Auctionadmin({Key key}) : super(key: key);

  @override
  _AuctionadminState createState() => _AuctionadminState();
}

class _AuctionadminState extends State<Auctionadmin> {
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
  List<dynamic> Auctionadmindata = []; //ประกาศตัวแปร อาร์เรย์ ไว้
  int totalResults = 0;
  int page = 1;
  int pageSize = 10;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  //String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJsdW1lbi1qd3QiLCJzdWIiOjYsImlhdCI6MTYxNTcxNTA3NCwiZXhwIjoxNjE1ODAxNDc0fQ.qX0GNbwo7PNY8TD4AXYQwGywdrOVmolOYum9wg1sG84";

  @override
  void initState() {
    super.initState();
    _getauctionadmin();
    _auctionadmin();

    // _addressMem();
    // _DepositoryScreenoryType();
    // _shippingOption();
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    //ทุกครั้งที่รีเฟรชจะเคียร์อาร์เรย์และ set page เป็น 1
    setState(() {
      Auctionadmindata.clear();
      page = 1;
    });
    _getauctionadmin(); //ทุกครั้งที่ทำการรีเฟรช จะดึงข้อมูลใหม่
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
        _getauctionadmin();
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

  _getauctionadmin() async {
    try {
      setState(() {
        page == 1 ? isLoading = true : isLoading = false;
      });
      prefs = await SharedPreferences.getInstance();
      var tokenString = prefs.getString('token');
      var token = convert.jsonDecode(tokenString);
      var url = Uri.parse(
          pathAPI + 'api/get_auction?status=&page=$page&page_size=$pageSize');
      var response = await http.get(
        url,
        headers: {'Authorization': token['data']['token']},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> depdata = convert.jsonDecode(response.body);
        print(response.body);
        setState(() {
          totalResults = depdata['data']['total'];
          Auctionadmindata.addAll(depdata['data']['data']);
          isLoading = false;
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

  _auctionadmin() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    setState(() {
      //isLoading = true;
    });

    var url = Uri.parse(pathAPI + 'api/get_detail_auction');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token['data']['token']
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> dataDepositoryScreen =
          convert.jsonDecode(response.body);
      if (dataDepositoryScreen['code'] == 200) {
        //print(dataDepositoryScreen['message']);
        setState(() {
          dropdownValue = dataDepositoryScreen['data'];
        });
        // for (var i = 0; i < dataValue.length; i++) {
        //   dropdownValue += dataValue[i]['name'];
        //   //print(dataValue[i]['name']);
        // }
        //print(dataValue[0]['name']);
      } else {}
    } else {}
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = Io.File(pickedFile.path);
        final bytes = Io.File(pickedFile.path).readAsBytesSync();
        // String base64Encode(List<int> bytes) => base64.encode(bytes);
        img64 = base64Encode(bytes);
        print(img64);
      } else {
        print('No image selected.');
      }
    });
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
              title: Text("รายการประมูล"),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    MyNavigator.goToHomeServices(context);
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
                        child: Auctionadmindata.length > 0
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: Auctionadmindata.length,
                                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                itemBuilder: (BuildContext context, int index) {
                                  return Auctionadmindata[index]['step'] !=
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
                                                      Auctionadmindata[index]
                                                                  ['image'] !=
                                                              null
                                                          ? launch(
                                                              Auctionadmindata[
                                                                      index]
                                                                  ['image'])
                                                          : SizedBox(
                                                              height: 0,
                                                            );
                                                    },
                                                    child: Image.network(
                                                        Auctionadmindata[index]
                                                                    ['image'] ==
                                                                null
                                                            ? 'https://picsum.photos/200/300'
                                                            : Auctionadmindata[
                                                                index]['image'],
                                                        width: 70),
                                                  ),
                                                ),
                                                title: GestureDetector(
                                                  onTap: () {
                                                    MyNavigator
                                                        .goToTimelineauction(
                                                            context,
                                                            Auctionadmindata[
                                                                index]['id']);
                                                  },
                                                  child: Text(
                                                    Auctionadmindata[index]
                                                        ['code'],
                                                    style: TextStyle(
                                                        color: kTextButtonColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                subtitle: GestureDetector(
                                                  onTap: () {
                                                    MyNavigator
                                                        .goToTimelineauction(
                                                            context,
                                                            Auctionadmindata[
                                                                index]['id']);
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
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
                                                                    Auctionadmindata[
                                                                            index]
                                                                        [
                                                                        'name'],
                                                                style: TextStyle(
                                                                    color:
                                                                        kTextButtonColor),
                                                              ),
                                                              maxLines: 3,
                                                              softWrap: true,
                                                            ),
                                                            RichText(
                                                              text: TextSpan(
                                                                text: "ชื่อลูกค้า :" +
                                                                    Auctionadmindata[
                                                                            index]
                                                                        [
                                                                        'code'],
                                                                style: TextStyle(
                                                                    color:
                                                                        kTextButtonColor),
                                                              ),
                                                              maxLines: 3,
                                                              softWrap: true,
                                                            ),
                                                            RichText(
                                                              text: TextSpan(
                                                                text: "เบอร์ติดต่อ :" +
                                                                    Auctionadmindata[
                                                                            index]
                                                                        [
                                                                        'code'],
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
                                                                    Auctionadmindata[index]
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
                                                trailing: GestureDetector(
                                                  onTap: () {
                                                    MyNavigator
                                                        .goToTimelineauction(
                                                            context,
                                                            Auctionadmindata[
                                                                index]['id']);
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(Icons
                                                            .keyboard_arrow_right_outlined),
                                                        color:
                                                            Colors.orange[900],
                                                        iconSize: 30,
                                                        onPressed: () {},
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
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
                        child: Auctionadmindata.length > 0
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: Auctionadmindata.length,
                                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                itemBuilder: (BuildContext context, int index) {
                                  return Auctionadmindata[index]['step'] ==
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
                                                      Auctionadmindata[index]
                                                                  ['image'] !=
                                                              null
                                                          ? launch(
                                                              Auctionadmindata[
                                                                      index]
                                                                  ['image'])
                                                          : SizedBox(
                                                              height: 0,
                                                            );
                                                    },
                                                    child: Image.network(
                                                        Auctionadmindata[index]
                                                                    ['image'] ==
                                                                null
                                                            ? 'https://picsum.photos/200/300'
                                                            : Auctionadmindata[
                                                                index]['image'],
                                                        width: 70),
                                                  ),
                                                ),
                                                title: GestureDetector(
                                                  onTap: () {
                                                    MyNavigator
                                                        .goToTimelineauction(
                                                            context,
                                                            Auctionadmindata[
                                                                index]['id']);
                                                  },
                                                  child: Text(
                                                    Auctionadmindata[index]
                                                        ['code'],
                                                    style: TextStyle(
                                                        color: kTextButtonColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                subtitle: GestureDetector(
                                                  onTap: () {
                                                    MyNavigator
                                                        .goToTimelineauction(
                                                            context,
                                                            Auctionadmindata[
                                                                index]['id']);
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
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
                                                                    Auctionadmindata[
                                                                            index]
                                                                        [
                                                                        'name'],
                                                                style: TextStyle(
                                                                    color:
                                                                        kTextButtonColor),
                                                              ),
                                                              maxLines: 3,
                                                              softWrap: true,
                                                            ),
                                                            RichText(
                                                              text: TextSpan(
                                                                text: "ชื่อลูกค้า :" +
                                                                    Auctionadmindata[
                                                                            index]
                                                                        [
                                                                        'code'],
                                                                style: TextStyle(
                                                                    color:
                                                                        kTextButtonColor),
                                                              ),
                                                              maxLines: 3,
                                                              softWrap: true,
                                                            ),
                                                            RichText(
                                                              text: TextSpan(
                                                                text: "เบอร์ติดต่อ :" +
                                                                    Auctionadmindata[
                                                                            index]
                                                                        [
                                                                        'code'],
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
                                                                    Auctionadmindata[index]
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
                                                trailing: GestureDetector(
                                                  onTap: () {
                                                    MyNavigator
                                                        .goToTimelineauction(
                                                            context,
                                                            Auctionadmindata[
                                                                index]['id']);
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(Icons
                                                            .keyboard_arrow_right_outlined),
                                                        color:
                                                            Colors.orange[900],
                                                        iconSize: 30,
                                                        onPressed: () {},
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
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
        ));
  }

  Card addressCard(String title, String title1, String subtitle) {
    return Card(
      color: Colors.orange[50],
      child: ListTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title == null
                ? Text("...")
                : Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: kTextButtonColor),
                  ),
            title1 == null
                ? Text("...")
                : Text(
                    title1,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: kTextButtonColor),
                  ),
          ],
        ),
        subtitle: subtitle == null
            ? Text("...")
            : Text(
                subtitle,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: kTextButtonColor),
              ),
        trailing: IconButton(
            icon: Icon(
              Icons.edit,
              size: 25,
            ),
            onPressed: () {
              showDialog(
                //barrierDismissible: false,
                context: context,
                builder: (context) => selectdialog(
                  context,
                ),
              );
              //selectdialog();
            }),
      ),
    );
  }

  Card selectCard(String title, String title1, String subtitle, int index) {
    return Card(
      color: kFontPrimaryColor,
      child: ListTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: kTextButtonColor),
            ),
            Text(
              title1,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: kTextButtonColor),
            ),
          ],
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: kTextButtonColor),
        ),
        trailing: IconButton(
            icon: Icon(
              Icons.edit,
              size: 25,
            ),
            onPressed: () {
              setState(() {
                id = address[index]['id'];
                name = title;
                add = title1;
                tel = subtitle;
              });
              Navigator.pop(context);
              //selectdialog();
            }),
      ),
    );
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
        child: Container(
          height: 350,
          child: Column(
            children: [
              Text("เลือกที่อยู่",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18,
                  )),
              Container(
                height: 300,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: address.length,
                          itemBuilder: (BuildContext context, int index) {
                            return selectCard(
                              address[index]['name'],
                              address[index]['address'],
                              address[index]['tel'],
                              index,
                            );
                          }),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    showDialog(
                      //barrierDismissible: false,
                      context: context,
                      builder: (context) => addDialog(
                        context,
                      ),
                    );
                  },
                  child: Text("เพิ่มที่อยู่")),
            ],
          ),
        ),
      ),
    );
  }

  addDialog(context) {
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
        child: Container(
          height: 390,
          child: SingleChildScrollView(
            child: FormBuilder(
              key: _formKey1,
              initialValue: {
                'name': '',
                'description': '',
                'tel': '',
              },
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        FormBuilderTextField(
                          name: 'name',
                          decoration: InputDecoration(
                              //border: InputBorder.none,
                              border: OutlineInputBorder(),
                              fillColor: Color(0xfff3f3f4),
                              filled: true),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                            // FormBuilderValidators.numeric(context),
                            // FormBuilderValidators.max(context, 70),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        FormBuilderTextField(
                          name: 'description',
                          maxLines: 2,
                          decoration: InputDecoration(
                              //border: InputBorder.none,
                              border: OutlineInputBorder(),
                              fillColor: Color(0xfff3f3f4),
                              filled: true),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                            // FormBuilderValidators.numeric(context),
                            // FormBuilderValidators.max(context, 70),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tel",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        FormBuilderTextField(
                          keyboardType: TextInputType.number,
                          name: 'tel',
                          decoration: InputDecoration(
                              //border: InputBorder.none,
                              border: OutlineInputBorder(),
                              fillColor: Color(0xfff3f3f4),
                              filled: true),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                            // FormBuilderValidators.numeric(context),
                            // FormBuilderValidators.max(context, 70),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_formKey1.currentState.validate()) {
                              _formKey1.currentState.save();
                            } else {}
                            // _formKey.currentState.save();
                            // print(_formKey.currentState.value);
                            // _preorderMem(
                            //     _formKey.currentState.value);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    offset: Offset(2, 4),
                                    blurRadius: 5,
                                    spreadRadius: 2)
                              ],
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xffdd4b39),
                                    Color(0xffdd4b39)
                                  ]),
                            ),
                            child: Text(
                              "ยืนยัน",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
