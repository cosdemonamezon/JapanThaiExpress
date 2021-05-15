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

class DepositoryScreen extends StatefulWidget {
  DepositoryScreen({Key key}) : super(key: key);

  @override
  _DepositoryScreenState createState() => _DepositoryScreenState();
}

class _DepositoryScreenState extends State<DepositoryScreen> {
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
  List<dynamic> DepositoryScreendata = []; //ประกาศตัวแปร อาร์เรย์ ไว้
  int totalResults = 0;
  int page = 1;
  int pageSize = 10;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  //String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJsdW1lbi1qd3QiLCJzdWIiOjYsImlhdCI6MTYxNTcxNTA3NCwiZXhwIjoxNjE1ODAxNDc0fQ.qX0GNbwo7PNY8TD4AXYQwGywdrOVmolOYum9wg1sG84";

  @override
  void initState() {
    super.initState();
    _getDepositoryScreenory();
    _addressMem();
    _DepositoryScreenoryType();
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    //ทุกครั้งที่รีเฟรชจะเคียร์อาร์เรย์และ set page เป็น 1
    setState(() {
      DepositoryScreendata.clear();
      page = 1;
    });
    _getDepositoryScreenory(); //ทุกครั้งที่ทำการรีเฟรช จะดึงข้อมูลใหม่
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
        _getDepositoryScreenory();
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

  _getDepositoryScreenory() async {
    try {
      setState(() {
        page == 1 ? isLoading = true : isLoading = false;
      });
      prefs = await SharedPreferences.getInstance();
      var tokenString = prefs.getString('token');
      var token = convert.jsonDecode(tokenString);
      var url = Uri.parse(pathAPI +
          'api/get_depository?status=&page=$page&page_size=$pageSize');
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
          DepositoryScreendata.addAll(depdata['data']['data']);
          isLoading = false;
          // print(depdata['message']);
          // print(totalResults);
          // print("test");
          // print(DepositoryScreendata.length);
          // print(DepositoryScreendata[1]['description']);
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

  _DepositoryScreenoryType() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    setState(() {
      //isLoading = true;
    });

    var url = Uri.parse(pathAPI + 'api/DepositoryScreenory_type');
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

  _addressMem() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    //print(token);
    setState(() {
      //isLoading = true;
      // tokendata = token['data']['token'];
    });
    //print(tokendata);

    var url = Uri.parse(pathAPI + 'api/address_mem');
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': token['data']['token'],
    });
    if (response.statusCode == 200) {
      final Map<String, dynamic> addressdata =
          convert.jsonDecode(response.body);
      //print(addressdata);
      setState(() {
        address = addressdata['data'];
        id = address[0]['id'];
        name = address[0]['name'];
        add = address[0]['address'];
        tel = address[0]['tel'];
      });
    } else {
      final Map<String, dynamic> addressdata =
          convert.jsonDecode(response.body);
      print(addressdata['message']);
    }
  }

  _createDepositoryScreenory(Map<String, dynamic> values) async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    print(values);
    print(_transport);
    print(costth);
    print(id);
    print(img64);
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(pathAPI + 'api/create_DepositoryScreenory');
    var response = await http.post(url,
        headers: {
          //'Content-Type': 'application/json',
          'Authorization': token['data']['token']
        },
        body: ({
          'add_id': id.toString(),
          'image': "data:image/png;base64," + img64,
          'description': values['option'],
          'cost_th': costth,
        }));
    if (response.statusCode == 201) {
      final Map<String, dynamic> DepositoryScreendata =
          convert.jsonDecode(response.body);
      print(DepositoryScreendata);
      if (DepositoryScreendata['code'] == 201) {
        print(DepositoryScreendata['message']);
        //MyNavigator.goToDepositoryScreen(context);
        // Navigator.push(
        //   context, MaterialPageRoute(builder: (context) => DepositoryScreen()));
        // String picSuccess = "assets/success.png";
        // showDialog(
        //   barrierDismissible: false,
        //   context: context,
        //   builder: (context) => alertDepositoryScreen(
        //     DepositoryScreendata['message'],
        //     picSuccess,
        //     context,
        //   ),
        // );
      } else {}
    } else {
      print("error");
      var feedback = convert.jsonDecode(response.body);
      print("${feedback['message']}");
      Flushbar(
        title: '${feedback['message']}',
        message: 'เกิดข้อผิดพลาดจากระบบ : ${feedback['code']}',
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
              title: Text("รายการฝากส่ง"),
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
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: DepositoryScreendata.length,
                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    MyNavigator.goToTimelineDepository(context,
                                        DepositoryScreendata[index]['id']);
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 4.0,
                                    child: Container(
                                      decoration:
                                          BoxDecoration(color: Colors.white),
                                      child: ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 10.0),
                                          leading: Container(
                                            padding:
                                                EdgeInsets.only(right: 14.0),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    right: BorderSide(
                                                        width: 2.0,
                                                        color: primaryColor))),
                                            child: Image.network(
                                                DepositoryScreendata[index]
                                                            ['image'] ==
                                                        null
                                                    ? 'https://picsum.photos/200/300'
                                                    : DepositoryScreendata[
                                                        index]['image'],
                                                width: 70),
                                          ),
                                          title: Text(
                                            DepositoryScreendata[index]
                                                ['description'],
                                            style: TextStyle(
                                                color: kTextButtonColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Row(
                                            children: <Widget>[
                                              Flexible(
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                    RichText(
                                                      text: TextSpan(
                                                        text: "ชื่อลูกค้า :" +
                                                            DepositoryScreendata[
                                                                    index]
                                                                ['ship_name'],
                                                        style: TextStyle(
                                                            color:
                                                                kTextButtonColor),
                                                      ),
                                                      maxLines: 3,
                                                      softWrap: true,
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                        text: "เบอร์โทร :" +
                                                            DepositoryScreendata[
                                                                    index]
                                                                ['ship_tel'],
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
                                                            DepositoryScreendata[
                                                                        index][
                                                                    'created_at']
                                                                .split("T")[0],
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
                                                color: Colors.orange[900],
                                                iconSize: 30,
                                                onPressed: () {
                                                  MyNavigator
                                                      .goToTimelineDepository(
                                                          context,
                                                          DepositoryScreendata[
                                                              index]['id']);
                                                },
                                              ),
                                            ],
                                          )
                                          /*trailing: MaterialButton(
                                          onPressed: () {
                                            MyNavigator.goToTimelineDepository(
                                                context,
                                                DepositoryScreendata[index]
                                                    ['id']);
                                          },
                                          color: Color(0xffdd4b39),
                                          child: Text(
                                            "ดูเพิ่ม",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),*/
                                          //onTap: () {},
                                          ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
              ),
              //tab 2
              Icon(Icons.movie),
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

  Card buildCard(
    String title,
    String title2,
    String title3,
    String title4,
  ) {
    return Card(
      child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Text(
                title2,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Text(
                title3,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Text(
                title4,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MaterialButton(
                onPressed: () {
                  //MyNavigator.goToTimelineOrders(context);
                },
                color: Colors.green,
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
