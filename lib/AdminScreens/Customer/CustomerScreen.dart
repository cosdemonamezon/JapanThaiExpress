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

class CustomerScreen extends StatefulWidget {
  CustomerScreen({Key key}) : super(key: key);

  @override
  _CustomerScreendataState createState() => _CustomerScreendataState();
}

class _CustomerScreendataState extends State<CustomerScreen> {
  TextEditingController controller = TextEditingController();
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
  List<dynamic> CustomerScreens = []; //ประกาศตัวแปร อาร์เรย์ ไว้
  List<dynamic> CustomerScreen = [];
  int totalResults = 0;
  int page = 1;
  int pageSize = 10;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  //String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJsdW1lbi1qd3QiLCJzdWIiOjYsImlhdCI6MTYxNTcxNTA3NCwiZXhwIjoxNjE1ODAxNDc0fQ.qX0GNbwo7PNY8TD4AXYQwGywdrOVmolOYum9wg1sG84";

  @override
  void initState() {
    super.initState();
    _getCustomers();
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    //ทุกครั้งที่รีเฟรชจะเคียร์อาร์เรย์และ set page เป็น 1
    _getCustomers(); //ทุกครั้งที่ทำการรีเฟรช จะดึงข้อมูลใหม่
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    //ทุกครั้งที่รีเฟรชจะเคียร์อาร์เรย์และ set page เป็น 1
    _getCustomers(); //ทุกครั้งที่ทำการรีเฟรช จะดึงข้อมูลใหม่
    _refreshController.refreshCompleted();
  }

  _getCustomers() async {
    try {
      setState(() {
        page == 1 ? isLoading = true : isLoading = false;
      });
      prefs = await SharedPreferences.getInstance();
      var tokenString = prefs.getString('token');
      var token = convert.jsonDecode(tokenString);
      var url = Uri.parse(
          pathAPI + 'api/app/members?status=&page=$page&page_size=$pageSize');
      var response = await http.get(
        url,
        headers: {'Authorization': token['data']['token']},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> depdata = convert.jsonDecode(response.body);
        setState(() {
          CustomerScreens = [];
          totalResults = depdata['data']['total'];
          CustomerScreens.addAll(depdata['data']['data']);
          isLoading = false;
          // print(depdata['message']);
          // print(totalResults);
          // print("test");
          // print(CustomerScreen.length);
          // print(CustomerScreen[1]['description']);
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

  onSearchTextChanged(String text) async {
    CustomerScreen.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    CustomerScreens.forEach((CustomerScreens) {
      if (CustomerScreens['fname_th'].contains(text) ||
          CustomerScreens['lname_th'].contains(text) ||
          CustomerScreens['tel'].contains(text))
        CustomerScreen.add(CustomerScreens);
    });

    setState(() {});
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
            title: Text("รายชื่อสมาชิก"),
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  Navigator.pop(context, true);
                }),
          ),
          body: Container(
            height: height,
            color: Colors.grey[300],
            child: isLoading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Container(
                        color: Theme.of(context).primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Card(
                            child: ListTile(
                              leading: Icon(Icons.search),
                              title: TextField(
                                controller: controller,
                                decoration: InputDecoration(
                                    hintText: 'ค้นหาชื่อ หรือ เบอร์โทร',
                                    border: InputBorder.none),
                                onChanged: onSearchTextChanged,
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () {
                                  controller.clear();
                                  onSearchTextChanged('');
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
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
                          child: CustomerScreen.length != 0 ||
                                  controller.text.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: CustomerScreen.length,
                                  padding:
                                      EdgeInsets.only(left: 5.0, right: 5.0),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: GestureDetector(
                                        onTap: () {
                                          MyNavigator.goToCustomerDetail(
                                              context, CustomerScreen, index);
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
                                                      horizontal: 10.0,
                                                      vertical: 10.0),
                                              leading: Container(
                                                padding:
                                                    EdgeInsets.only(right: 4.0),
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        right: BorderSide(
                                                            width: 2.0,
                                                            color:
                                                                primaryColor))),
                                                child: Image.network(
                                                    CustomerScreen[index][
                                                                    'profile'] !=
                                                                null &&
                                                            CustomerScreen[
                                                                        index][
                                                                    'profile'] !=
                                                                ""
                                                        ? CustomerScreen[index]
                                                            ['profile']
                                                        : 'https://picsum.photos/200/300',
                                                    width: 70),
                                              ),
                                              title: Text('คุณ ' +
                                                  CustomerScreen[index]
                                                      ['fname_th'] +
                                                  ' ' +
                                                  CustomerScreen[index]
                                                      ['lname_th']),
                                              subtitle: Text('โทร ' +
                                                  CustomerScreen[index]['tel']),
                                              trailing: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_right_outlined),
                                                    color: Colors.orange[900],
                                                    iconSize: 30,
                                                    onPressed: () {},
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: CustomerScreens.length,
                                  padding:
                                      EdgeInsets.only(left: 5.0, right: 5.0),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: GestureDetector(
                                        onTap: () {
                                          MyNavigator.goToCustomerDetail(
                                              context, CustomerScreens, index);
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
                                                      horizontal: 10.0,
                                                      vertical: 10.0),
                                              leading: Container(
                                                padding:
                                                    EdgeInsets.only(right: 4.0),
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        right: BorderSide(
                                                            width: 2.0,
                                                            color:
                                                                primaryColor))),
                                                child: Image.network(
                                                    CustomerScreens[index][
                                                                    'profile'] !=
                                                                null &&
                                                            CustomerScreens[
                                                                        index][
                                                                    'profile'] !=
                                                                ""
                                                        ? CustomerScreens[index]
                                                                ['profile']
                                                            .toString()
                                                        : 'https://picsum.photos/200/300',
                                                    width: 70),
                                              ),
                                              title: Text('คุณ ' +
                                                  CustomerScreens[index]
                                                      ['fname_th'] +
                                                  ' ' +
                                                  CustomerScreens[index]
                                                      ['lname_th']),
                                              subtitle: Text('โทร ' +
                                                  CustomerScreens[index]
                                                      ['tel']),
                                              trailing: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_right_outlined),
                                                    color: Colors.orange[900],
                                                    iconSize: 30,
                                                    onPressed: () {},
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                        ),
                      ),
                    ],
                  ),
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
