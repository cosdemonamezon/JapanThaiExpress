import 'dart:convert';

import 'package:JapanThaiExpress/UserScreens/Service/Service.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:JapanThaiExpress/alert.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:JapanThaiExpress/constants.dart';
import 'dart:io' as Io;

class Auction extends StatefulWidget {
  Auction({Key key}) : super(key: key);

  @override
  _AuctionState createState() => _AuctionState();
}

class _AuctionState extends State<Auction> {
  Map<String, dynamic> datasetting = {};
  String budget = "0";
  String service = "0";
  String rate = "0";
  String total = "0";
  SharedPreferences prefs;
  String _transport;
  String costth;
  int page = 1;
  int pageSize = 10;
  int totalResults = 0;
  List<dynamic> auctiondata = []; //ประกาศตัวแปร อาร์เรย์ ไว้
  final _formKey = GlobalKey<FormBuilderState>();
  final _formKey1 = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<bool> checked = [false, true, false, false, true];
  String valueChoose;
  List dropdownValue = [];
  Io.File _image;
  final picker = ImagePicker();
  String img64;
  int id;
  String name;
  String add;
  String tel;
  List address = [];

  @override
  void initState() {
    super.initState();
    _getauction();
    _shippingOption();
    // _addressMem();
    _depositoryType();
    _settingApp();
    _addressMem();
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

  _shippingOption() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    setState(() {
      //isLoading = true;
    });

    var url = pathAPI + 'api/shipping_option';
    var response = await http.get(
      Uri.parse(url),
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
          dropdownValue = dataship['data'];
          _transport = dropdownValue[0]['name'];
          costth = dropdownValue[0]['price'];
        });
        print(dropdownValue);
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

  _depositoryType() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    setState(() {
      //isLoading = true;
    });

    var url = pathAPI + 'api/shipping_option';
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token['data']['token']
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> dataauction =
          convert.jsonDecode(response.body);
      if (dataauction['code'] == 200) {
        // print(dataauction['message']);
        setState(() {
          dropdownValue = dataauction['data'];
        });
        // for (var i = 0; i < dataValue.length; i++) {
        //   dropdownValue += dataValue[i]['name'];
        //   //print(dataValue[i]['name']);
        // }
        //print(dataValue[0]['name']);
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
        //print(img64);
      } else {
        print('No image selected.');
      }
    });
  }

  _preorderMem(Map<String, dynamic> values) async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    // print(values);
    // print(rate);
    // print(service);
    // print(img64);

    var url = Uri.parse(pathAPI + 'api/app/auction');
    var response = await http.post(url,
        headers: {
          //'Content-Type': 'application/json',
          'Authorization': token['data']['token']
        },
        body: ({
          //'amount': values['amount'],
          'add_id': id.toString(),
          'url': values['url'],
          'name': values['name'],
          'budget': values['budget'],
          'shipping_option': values['option'],
          'description': '',
          'image': "data:image/png;base64," + img64,
          'promotion_code': '',
          'rate': rate,
          'fee': service,
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
          builder: (context) => alertAuction(
            creatdata['message'],
            picSuccess,
            context,
          ),
        );
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
        setState(() {
          isLoading = false;
        });
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

    // showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (context) => alertAuction(
    //     '',
    //     '',
    //     '',
    //   ),
    // );
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    //ทุกครั้งที่รีเฟรชจะเคียร์อาร์เรย์และ set page เป็น 1
    setState(() {
      auctiondata.clear();
      page = 1;
    });
    _getauction(); //ทุกครั้งที่ทำการรีเฟรช จะดึงข้อมูลใหม่
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
        _getauction();
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

  _getauction() async {
    try {
      setState(() {
        page == 1 ? isLoading = true : isLoading = false;
      });
      prefs = await SharedPreferences.getInstance();
      var tokenString = prefs.getString('token');
      var token = convert.jsonDecode(tokenString);
      var url = pathAPI +
          'api/app/auction_page?status=&page=$page&page_size=$pageSize';
      var response = await http.get(
        Uri.parse(url),
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
          auctiondata.addAll(depdata['data']['data']);
          isLoading = false;
          print(auctiondata);
          print(depdata['message']);
          print(totalResults);
          print("test");
          print(auctiondata.length);
          //print(data[1]['description']);
        });
      } else {
        setState(() {
          isLoading = false;
        });
        var feedback = convert.jsonDecode(response.body);
        Flushbar(
          title: '${feedback['message']}',
          message: 'ท่านยังไม่มีการสร้างรายการใหม่',
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
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  _settingApp() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    setState(() {
      isLoading = true;
    });

    var url = pathAPI + 'api/setting_app';
    var response = await http.get(Uri.parse(url), headers: {
      //'Content-Type': 'application/json',
      'Authorization': token['data']['token']
    });
    if (response.statusCode == 200) {
      final Map<String, dynamic> settingdata =
          convert.jsonDecode(response.body);
      //print(settingdata);
      if (settingdata['code'] == 200) {
        setState(() {
          datasetting = settingdata['data'];
          // rate = datasetting['exchange_rate'].toString();
          // fee = datasetting['fee'].toString();
          //_rate = TextEditingController(text: datasetting['exchange_rate'].toString());
          service = datasetting['fee'].toString();
          //_com = TextEditingController(text: datasetting['exhange_com'].toString());
          rate = datasetting['exchange_rate'].toString();
          //fee = _fee.text;
          // com = _com.text;
        });
        // print(_rate);
        // print(_fee);
      } else {
        print("error");
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
      print("error");
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
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text("ประมูลสินค้า"),
              leading: IconButton(
                  onPressed: () {
                    //Navigator.pop(context);
                    //MyNavigator.goToService(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Service()));
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
                        child: Text("ประมูลสินค้า"),
                      ),
                    ),
                  ])),
          body: TabBarView(children: [
            Container(
              height: height,
              color: Colors.white,
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
                      child: auctiondata.length > 0
                          ? ListView.builder(
                              itemCount: auctiondata.length,
                              itemBuilder: (BuildContext context, int index) {
                                return buildCard(
                                  auctiondata[index]['image'],
                                  auctiondata[index]['name'],
                                  auctiondata[index]['code'] == null
                                      ? 'ไม่มีข้อมูล'
                                      : auctiondata[index]['code'],
                                  auctiondata[index]['budget'] == null
                                      ? 'ไม่มีข้อมูล'
                                      : auctiondata[index]['budget'],
                                  auctiondata[index]['track_jp'] == null
                                      ? 'ไม่มีข้อมูล'
                                      : auctiondata[index]['track_jp'],
                                  auctiondata[index]['id'],
                                );
                              }
                              // buildCard(
                              //   "Hi everyone in this flutter article I am working with flutter button UI Design. Flutter button with image",
                              //   "assets/o8.jpg",
                              // ),
                              // buildCard(
                              //   "Buttons are the Flutter widgets, which is a part of the material design library. Flutter provides several types of buttons that have different shapes",
                              //   "assets/o7.jpg",
                              // ),

                              )
                          : Center(child: Text('ไม่พบรายการ')),
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
                    'url': '',
                    'name': '',
                    'budget': '',
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: height * .03),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "URL*",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(height: 10),
                            FormBuilderTextField(
                              name: 'url',
                              keyboardType: TextInputType.url,
                              maxLines: 1,
                              obscureText: false,
                              decoration: InputDecoration(
                                  //border: InputBorder.none,
                                  border: OutlineInputBorder(),
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true),
                              // valueTransformer: (text) => num.tryParse(text),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
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
                              "ชื่อสินค้า",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(height: 5),
                            FormBuilderTextField(
                              name: 'name',
                              maxLines: 1,
                              obscureText: false,
                              decoration: InputDecoration(
                                  //border: InputBorder.none,
                                  border: OutlineInputBorder(),
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true),
                              // valueTransformer: (text) => num.tryParse(text),
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
                              "งบประมาณ*",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(height: 10),
                            FormBuilderTextField(
                              keyboardType: TextInputType.number,
                              name: 'budget',
                              maxLines: 1,
                              obscureText: false,
                              decoration: InputDecoration(
                                  //border: InputBorder.none,
                                  border: OutlineInputBorder(),
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true),
                              // valueTransformer: (text) => num.tryParse(text),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                              ]),
                              onChanged: (text) {
                                if (text.isEmpty || text == null) {
                                  setState(() {
                                    budget = '0';
                                    total = '0';
                                  });
                                } else {
                                  var c;
                                  var x = double.parse('$text');
                                  var a = double.parse('$rate');
                                  var b = double.parse('$service');
                                  c = (x + b) * a;

                                  setState(() {
                                    budget = text;
                                    total = c.toString();
                                  });
                                }

                                // //   var c = double.parse('$total');
                                // //   var y = x+b;
                                // //   var z = y*a;
                                // //   var m=0+z;
                                // if (text != null) {

                                // }
                                // print(text);
                              },
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
                            Text(
                              "รูปแบบการจัดส่ง*",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(height: 10),
                            FormBuilderDropdown(
                              name: 'option',
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: '',
                              ),
                              // initialValue: 'Male',
                              allowClear: true,
                              hint: Text('รูปแบบการจัดส่ง'),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(context)]),
                              items: dropdownValue
                                  .map((option) => DropdownMenuItem(
                                        value: option['name'],
                                        child: Text(option['name']),
                                      ))
                                  .toList(),
                            ),
                            SizedBox(height: 10),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "ที่อยู่",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
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
                                  Text(
                                    "ค่าใช้จ่าย",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                            Container(
                              width: width * 0.9,
                              height: height * 0.15,
                              color: Colors.blue[50],
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text("งบประมาณ"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text(budget + " เยน"),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text("ค่าบริการ"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text(service + " เยน"),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text("เรท"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text(rate + " บาท"),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text("รวม"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text(total + " บาท"),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                getImage();
                              },
                              child: Center(
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  //color: Colors.red,
                                  child: _image == null
                                      ? Image.asset("assets/images/nopic.png")
                                      : Image.file(
                                          _image,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            GestureDetector(
                              onTap: () {
                                // String picSuccess = "assets/success.png";
                                // showDialog(
                                //   barrierDismissible: false,
                                //   context: context,
                                //   builder: (context) => alertAuction(
                                //     'ดำเนินการสำเร็จ',
                                //     picSuccess,
                                //     context,
                                //   ),
                                // );
                                setState(() {
                                  isLoading = true;
                                });
                                _formKey.currentState.save();
                                // print(_formKey.currentState.value);
                                _preorderMem(_formKey.currentState.value);
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
          ]),
          bottomNavigationBar: NavigationBar(),
        ));
  }

  Card buildCard(
    String image,
    String title,
    String title2,
    String title3,
    String title4,
    int id,
  ) {
    return Card(
      child: GestureDetector(
        onTap: () {
          MyNavigator.goToTimelineauctionMember(context, id);
        },
        child: ListTile(
          leading: Container(
              width: 90,
              height: 150,
              child: Image.network(
                image,
                fit: BoxFit.cover,
              )),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "ชื่อ：" + title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Text(
                "โค้ด：" + title2,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Text(
                "ราคา：" + title3,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_right_outlined),
                color: Colors.orange[900],
                iconSize: 30,
                onPressed: () {},
              ),
            ],
          ),
          /*subtitle: Row(
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
            )*/
        ),
      ),
    );
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
}
