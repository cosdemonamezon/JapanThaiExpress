import 'dart:io' as Io;
import 'dart:convert';
import 'package:JapanThaiExpress/UserScreens/Service/DetailStep.dart';
import 'package:JapanThaiExpress/UserScreens/Service/Service.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/alert.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Deposit extends StatefulWidget {
  Deposit({Key key}) : super(key: key);

  @override
  _DepositState createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
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
  List<dynamic> depositdata = []; //ประกาศตัวแปร อาร์เรย์ ไว้
  int totalResults = 0;
  int page = 1;
  int pageSize = 10;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  //String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJsdW1lbi1qd3QiLCJzdWIiOjYsImlhdCI6MTYxNTcxNTA3NCwiZXhwIjoxNjE1ODAxNDc0fQ.qX0GNbwo7PNY8TD4AXYQwGywdrOVmolOYum9wg1sG84";

  @override
  void initState() {
    super.initState();
    _getDepository();
    _addressMem();
    _depositoryType();
    _shippingOption();
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    //ทุกครั้งที่รีเฟรชจะเคียร์อาร์เรย์และ set page เป็น 1
    setState(() {
      depositdata.clear();
      page = 1;
    });
    _getDepository(); //ทุกครั้งที่ทำการรีเฟรช จะดึงข้อมูลใหม่
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
        _getDepository();
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

  _getDepository() async {
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
          depositdata.addAll(depdata['data']['data']);
          isLoading = false;
          // print(depdata['message']);
          // print(totalResults);
          // print("test");
          // print(depositdata.length);
          // print(depositdata[1]['description']);
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

  _depositoryType() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    setState(() {
      //isLoading = true;
    });

    var url = Uri.parse(pathAPI + 'api/depository_type');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token['data']['token']
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> datadeposit =
          convert.jsonDecode(response.body);
      if (datadeposit['code'] == 200) {
        //print(datadeposit['message']);
        setState(() {
          dropdownValue = datadeposit['data'];
        });
        // for (var i = 0; i < dataValue.length; i++) {
        //   dropdownValue += dataValue[i]['name'];
        //   //print(dataValue[i]['name']);
        // }
        //print(dataValue[0]['name']);
      } else {}
    } else {}
  }

  _shippingOption() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    setState(() {
      //isLoading = true;
    });

    var url = Uri.parse(pathAPI + 'api/shipping_option');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token['data']['token']
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> dataship = convert.jsonDecode(response.body);
      if (dataship['code'] == 200) {
        print(dataship['message']);
        setState(() {
          dropdownShip = dataship['data'];
          _transport = dropdownShip[0]['name'];
          costth = dropdownShip[0]['price'];
        });
        print(dropdownShip);
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

  _createDepository(Map<String, dynamic> values) async {
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
    var url = Uri.parse(pathAPI + 'api/create_depository');
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
      final Map<String, dynamic> depositdata =
          convert.jsonDecode(response.body);
      print(depositdata);
      if (depositdata['code'] == 201) {
        print(depositdata['message']);
        //MyNavigator.goToDeposit(context);
        // Navigator.push(
        //   context, MaterialPageRoute(builder: (context) => Deposit()));
        String picSuccess = "assets/success.png";
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => alertDeposit(
            depositdata['message'],
            picSuccess,
            context,
          ),
        );
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

  _createAddmem(Map<String, dynamic> values) async {
    print(values);
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var url = Uri.parse(pathAPI + 'api/create_add_mem');
    var response = await http.post(url,
        headers: {
          //'Content-Type': 'application/json',
          'Authorization': token['data']['token']
        },
        body: ({
          'name': values['name'],
          'address': values['description'],
          'tel': values['tel'],
        }));
    if (response.statusCode == 201) {
      final Map<String, dynamic> creatdata = convert.jsonDecode(response.body);
      if (creatdata['code'] == 201) {
        setState(() {
          isLoading = false;
        });
        String picSuccess = "assets/success.png";
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => alertAddmember(
            creatdata['message'],
            picSuccess,
            context,
          ),
        );
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
              title: Text("รับฝากส่ง"),
              leading: IconButton(
                  onPressed: () {
                    MyNavigator.goToService(context);
                    // Navigator.push(
                    //   context, MaterialPageRoute(builder: (context) => Service()));
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                  )),
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
                        child: Text("รายการ"),
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("ฝากส่ง"),
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
                            itemCount: depositdata.length,
                            itemBuilder: (BuildContext context, int index) {
                              return buildCard(
                                depositdata[index]['image'],
                                depositdata[index]['ship_tel'],
                                depositdata[index]['ship_name'],
                                depositdata[index]['ship_address'],
                                depositdata[index]['description'] == null
                                    ? 'ไม่มีข้อมูล'
                                    : depositdata[index]['description'],
                              );
                            }),
                      ),
              ),
              //tab 2
              Container(
                height: height,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: FormBuilder(
                    key: _formKey,
                    initialValue: {
                      'add_id': id.toString(),
                      'image': img64,
                      'description': '',
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: height * .04),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ที่อยู่",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(height: 10),
                              addressCard(
                                name == null ? "" : name,
                                add == null ? "" : add,
                                tel == null ? "" : tel,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "รายละเอียด",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              // FormBuilderTextField(
                              //   name: 'description',
                              //   maxLines: 4,
                              //   decoration: InputDecoration(
                              //       //border: InputBorder.none,
                              //       border: OutlineInputBorder(),
                              //       fillColor: Color(0xfff3f3f4),
                              //       filled: true),
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(height: 1),
                        FormBuilderDropdown(
                          name: 'option',
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '',
                          ),
                          // initialValue: 'Male',
                          allowClear: true,
                          hint: Text('หมวดหมู่สินค้า'),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: 'กรุณาเลือกหมวดหมู่สินค้า')
                          ]),
                          items: dropdownValue
                              .map((option) => DropdownMenuItem(
                                    value: option['name'],
                                    child: Text(option['name']),
                                  ))
                              .toList(),
                        ),
                        SizedBox(height: 5),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "รูปแบบการจัดส่ง",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        FormBuilderDropdown(
                          name: 'shiping_option',
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '',
                          ),
                          // initialValue: 'Male',
                          allowClear: true,
                          hint: Text('รูปแบบการจัดส่ง'),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: 'กรุณาเลือกรูปแบบการจัดส่ง')
                          ]),
                          items: dropdownShip
                              .map((option) => DropdownMenuItem(
                                    value: option['name'],
                                    child: Text(option['name']),
                                  ))
                              .toList(),
                        ),
                        // for (int i = 1; i <= dropdownShip.length; i++)
                        //   ListTile(
                        //     title: Text(dropdownShip[i - 1]['name']),
                        //     leading: Radio(
                        //         value: i,
                        //         groupValue: _value,
                        //         activeColor: Color(0xFF6200EE),
                        //         onChanged: i > dropdownShip.length
                        //             ? null
                        //             : (int value) {
                        //                 setState(() {
                        //                   _value = value;
                        //                   _transport =
                        //                       dropdownShip[i - 1]['name'];
                        //                   costth = dropdownShip[i - 1]['price'];
                        //                   //print(costth);
                        //                 });
                        //               }),
                        //   ),
                        // FormBuilderRadioGroup(
                        //   name: name,
                        //   //options: options
                        // ),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Center(
                            child: Container(
                              height: 150,
                              width: 180,
                              //color: Colors.red,
                              child: _image == null
                                  ? Image.asset("assets/images/nopic.png")
                                  : Image.file(
                                      _image,
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    setState(() {
                                      isLoading = true;
                                    });
                                    _createDepository(
                                        _formKey.currentState.value);
                                  } else {}
                                  // if (isLoading == true) {
                                  //   print("กดไม่ได้");
                                  // } else {
                                  //   _formKey.currentState.save();
                                  //   print(_formKey.currentState.value);
                                  //   _createDepository(
                                  //       _formKey.currentState.value);
                                  // }
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
                                  child: isLoading == true
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : Text(
                                          "ยืนยัน",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
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
            ],
          ),
          bottomNavigationBar: NavigationBar(),
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
    String img,
    String title,
    String title2,
    String title3,
    String title4,
  ) {
    return Card(
      child: ListTile(
          leading: Container(
              width: 90,
              height: 150,
              child: Image.network(
                img,
                fit: BoxFit.cover,
              )),
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
                  fontWeight: FontWeight.w400,
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
                color: primaryColor,
                child: Text(
                  "ดูเพิ่ม",
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
          height: 390,
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
              SizedBox(
                height: 10,
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
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
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
                          colors: [Color(0xffdd4b39), Color(0xffdd4b39)]),
                    ),
                    child: Text("เพิ่มที่อยู่",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  )),
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
                              setState(() {
                                isLoading = true;
                              });
                              _formKey1.currentState.save();
                              _createAddmem(_formKey1.currentState.value);
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
                            child: isLoading == true
                                ? Center(child: CircularProgressIndicator())
                                : Text(
                                    "ยืนยัน",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
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
