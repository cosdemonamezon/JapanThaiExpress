import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:JapanThaiExpress/alert.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:JapanThaiExpress/constants.dart';

class Auction extends StatefulWidget {
  Auction({Key key}) : super(key: key);

  @override
  _AuctionState createState() => _AuctionState();
}

class _AuctionState extends State<Auction> {
  Map<String, dynamic> datasetting = {};
  String budget = "0";
  String service = "0";
  String rate = "";
  String total = "0";
  SharedPreferences prefs;
  String _transport;
  String costth;
  int page = 1;
  int pageSize = 10;
  int totalResults = 0;
  List<dynamic> auctiondata = []; //ประกาศตัวแปร อาร์เรย์ ไว้
  final _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<bool> checked = [false, true, false, false, true];
  String valueChoose;
  List dropdownValue = [];
  @override
  void initState() {
    super.initState();
    _getauction();
    _shippingOption();
    // _addressMem();
    _depositoryType();
    _settingApp();
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
          dropdownValue = dataship['data'];
          _transport = dropdownValue[0]['name'];
          costth = dropdownValue[0]['price'];
        });
        print(dropdownValue);
      } else {}
    } else {}
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
      url,
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
      } else {}
    } else {}
  }

  _preorderMem(Map<String, dynamic> values) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => alertAuction(
        '',
        '',
        '',
      ),
    );
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
        print('error from backend ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

_settingApp() async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    setState(() {
      isLoading = true;
    });

    var url = pathAPI + 'api/setting_app';
    var response = await http.get(
      url,
      headers: {
        //'Content-Type': 'application/json',
        'Authorization': token['data']['token']
      }
    );
    if (response.statusCode == 200){
      final Map<String, dynamic> settingdata = convert.jsonDecode(response.body);
      //print(settingdata);
      if (settingdata['code'] == 200) {
        setState(() {
          datasetting = settingdata['data'];
          // rate = datasetting['exchange_rate'].toString();
          // fee = datasetting['fee'].toString();
          //_rate = TextEditingController(text: datasetting['exchange_rate'].toString());
          service =datasetting['fee'].toString();
          //_com = TextEditingController(text: datasetting['exhange_com'].toString());
          rate = datasetting['exchange_rate'].toString();
          //fee = _fee.text;
         // com = _com.text;
        });
        // print(_rate);
        // print(_fee);
      } else {
        print("error");
      }
    }
    else{
      print("error");
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
                    MyNavigator.goToService(context);
                    //Navigator.push(
                    //context, MaterialPageRoute(builder: (context) => Auction()));
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
            isLoading == true
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
                        itemCount: auctiondata.length,
                        itemBuilder: (BuildContext context, int index) {
                          return buildCard(
                            auctiondata[index]['name'],
                            auctiondata[index]['note'] == null
                                ? 'ไม่มีข้อมูล'
                                : auctiondata[index]['note'],
                            auctiondata[index]['price'] == null
                                ? 'ไม่มีข้อมูล'
                                : auctiondata[index]['price'],
                            auctiondata[index]['track_jp'] == null
                                ? 'ไม่มีข้อมูล'
                                : auctiondata[index]['track_jp'],
                            auctiondata[index]['image'],
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

                        ),
                  ),
            Container(
              height: height,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
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
                            name: 'ชื่อสินค้า',
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
                            name: 'งบประมาณ', 
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
                             onChanged: (text){
                                /*var x = budget;
                                var a = double.parse('$rate');
                                var b = service;
                                var c = double.parse('$total');
                                var y = x+b;
                                //var z = y*a;
                                //var m=0+z; */
                                 
                               setState(() {
                                 budget=text;
                                 
                                
                                });
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
                                      child: Text(budget +" เยน"),
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
                          SizedBox(height: 15),
                          GestureDetector(
                            onTap: () {
                              String picSuccess = "assets/success.png";
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => alertAuction(
                                  'ดำเนินการสำเร็จ',
                                  picSuccess,
                                  context,
                                ),
                              );
                              // _formKey.currentState.save();
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
                              child: Text(
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
          ]),
          bottomNavigationBar: NavigationBar(),
        ));
  }

  Card buildCard(
      String title, String title2, String title3, String title4, String image) {
    return Card(
      child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: image == null
                ? NetworkImage(image)
                : NetworkImage("https://picsum.photos/200/300"),
          ),
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
                "ราคา：" + title3,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Text(
                "tag：" + title4,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14,
                ),
              )
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
}
