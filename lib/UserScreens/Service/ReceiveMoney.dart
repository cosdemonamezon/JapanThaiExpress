import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/alert.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:JapanThaiExpress/constants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceiveMoney extends StatefulWidget {
  ReceiveMoney({Key key}) : super(key: key);

  @override
  _ReceiveMoneyState createState() => _ReceiveMoneyState();
}

class _ReceiveMoneyState extends State<ReceiveMoney> {
  List<bool> checked = [false, true, false, false, true];
  bool isLoading = false;
  Map<String, dynamic> datasetting = {};
  String rate = "";
  String fee = "";
  String com = "";
  String sum = "";
  //final _formKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormBuilderState>();
  TextEditingController _rate;
  TextEditingController _fee;
  TextEditingController _com;
  TextEditingController _sum;
  SharedPreferences prefs;
  List<dynamic> exchangedata = []; //ประกาศตัวแปร อาร์เรย์ ไว้
  int totalResults = 0;
  int page = 1;
  int pageSize = 10;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _getExchange();
    _settingApp();
    _getRateJPY();
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    //ทุกครั้งที่รีเฟรชจะเคียร์อาร์เรย์และ set page เป็น 1
    setState(() {
      exchangedata.clear();
      page = 1;
    });
    _getExchange(); //ทุกครั้งที่ทำการรีเฟรช จะดึงข้อมูลใหม่
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
        _getExchange();
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

  _getExchange() async {
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
        final Map<String, dynamic> exchange = convert.jsonDecode(response.body);
        setState(() {
          totalResults = exchange['data']['total'];
          exchangedata.addAll(exchange['data']['data']);
          isLoading = false;
          // print(exchange['message']);
          // print(totalResults);
          // print("test");
          // print(exchangedata.length);
          // print(exchangedata[1]['description']);
        });
        print(exchangedata);
      } else {
        setState(() {
          isLoading = false;
        });
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
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  _getRateJPY() async {
    var ocpKey = 'ba0779b6ee0b460f9b3c64d9ae64f851';
    var url = Uri.parse(
        'https://bbl-sea-apim-p.azure-api.net/api/ExchangeRateService/FxCal/1/JPY/THB');
    var response = await http.get(url, headers: {
      //'Content-Type': 'application/json',
      'Ocp-Apim-Subscription-Key': ocpKey
    });
    if (response.statusCode == 200) {
      final String ratedata = convert.jsonDecode(response.body);
      setState(() {
        _rate = TextEditingController(text: ratedata.toString());
        rate = _rate.text;
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

  _settingApp() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    setState(() {
      isLoading = true;
    });

    var url = Uri.parse(pathAPI + 'api/setting_app');
    var response = await http.get(url, headers: {
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
          _fee = TextEditingController(text: datasetting['fee'].toString());
          _com = TextEditingController(
              text: datasetting['exhange_com'].toString());
          //rate = _rate.text;
          fee = _fee.text;
          com = _com.text;
        });
        // print(_rate);
        // print(_fee);
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

  _createExchange(Map<String, dynamic> values) async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    print(values);
    print(rate);
    print(fee);
    print(com);
    print(sum);
    // setState(() {
    //   isLoading = true;
    // });
    var url = Uri.parse(pathAPI + 'api/create_exchange');
    var response = await http.post(url,
        headers: {
          //'Content-Type': 'application/json',
          'Authorization': token['data']['token']
        },
        body: ({
          //'amount': values['amount'],
          'amount': values['amount'],
          'account_no': values['account_no'],
          'account_name': values['account_name'],
          'bank': values['bank'],
          'description': values['description'],
          'rate': rate,
          'exhange_fee': fee,
          'exhange_com': com,
          // 'rate': values['rate'],
          // 'fee': values['fee'],
        }));
    if (response.statusCode == 201) {
      final Map<String, dynamic> tranfer = convert.jsonDecode(response.body);
      //print(tranfer);
      if (tranfer['code'] == 201) {
        setState(() {
          isLoading = false;
        });
        print(tranfer['data']['total']);
        String picSuccess = "assets/success.png";
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => alertdialog(
            tranfer['message'],
            tranfer['data']['total'].toStringAsFixed(2),
            tranfer['data']['code'],
            tranfer['data']['updated_at'],
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
    } else if (response.statusCode == 402) {
      final Map<String, dynamic> trandata = convert.jsonDecode(response.body);
      print(trandata['message']);
      setState(() {
        isLoading = false;
      });
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => alertTranfer(
          trandata['message'],
          picWanning,
          context,
        ),
      );
      print(trandata['message']);
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text("รับโอนเงิน"),
            leading: IconButton(
                onPressed: () {
                  //MyNavigator.goToService(context);
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
                      child: Text("รับโอนเงิน"),
                    ),
                  ),
                ])),
        body: TabBarView(
          children: [
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
                      child: ListView.builder(
                          itemCount: exchangedata.length,
                          itemBuilder: (BuildContext context, int index) {
                            return buildCard(
                              exchangedata[index]['id'].toString(),
                              exchangedata[index]['code'].toString(),
                              exchangedata[index]['bank'].toString(),
                              exchangedata[index]['total'].toString(),
                              exchangedata[index]['description'] == null
                                  ? 'ไม่มีข้อมูล'
                                  : exchangedata[index]['description'].toString(),
                              exchangedata[index]['created_at'].toString(),
                              exchangedata[index]['status'].toString(),
                              exchangedata[index]['fee'].toString(),
                              exchangedata[index]['account_name'].toString(),
                              exchangedata[index]['account_no'].toString(),
                              exchangedata[index]['slip'] == null
                                  ? 'ไม่มีข้อมูล'
                                  : exchangedata[index]['slip'].toString(),
                            );
                          }),
                    ),
            ),
            //tap2
            Container(
              height: height,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: FormBuilder(
                  key: _formKey,
                  initialValue: {
                    'account_name': '',
                    'account_no': '',
                    'bank': '',
                    'amount': '',
                    'description': '',
                    'rate': rate,
                    'fee': fee,
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: height * .002),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ธนาคาร *",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(height: 10),
                            FormBuilderTextField(
                              name: 'bank',
                              decoration: InputDecoration(
                                  //border: InputBorder.none,
                                  border: OutlineInputBorder(),
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context,
                                    errorText: 'กรุณาเลือกธนาคาร')
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
                              "ชื่อบัญชี *",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(height: 10),
                            FormBuilderTextField(
                              name: 'account_name',
                              decoration: InputDecoration(
                                  //border: InputBorder.none,
                                  border: OutlineInputBorder(),
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context,
                                    errorText: 'กรุณากรอกชื่อบัญชี')
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
                              "เลขที่บัญชี *",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(height: 10),
                            FormBuilderTextField(
                              keyboardType: TextInputType.number,
                              name: 'account_no',
                              decoration: InputDecoration(
                                  //border: InputBorder.none,
                                  border: OutlineInputBorder(),
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context,
                                    errorText: 'กรุณากรอกเลขที่บัญชี')
                              ]),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        //width: width-80,
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "จำนวนเงิน *",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(height: 10),
                            FormBuilderTextField(
                              keyboardType: TextInputType.number,
                              name: 'amount',
                              decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    Icons.monetization_on_outlined,
                                    size: 30,
                                  ),
                                  //border: InputBorder.none,
                                  border: OutlineInputBorder(),
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true),
                              onChanged: (text) {
                                //print("First text field: $text");
                                var x =
                                    double.parse('$text'); //จำนวนเงิน ที่กรอก
                                var a =
                                    double.parse('$rate'); //อัตตราแลกเปลี่ยน
                                var b = double.parse('$fee'); //ค่าบริการ
                                var c = double.parse('$com'); //ค่าคอม
                                var y = x * a;
                                var z = y * c;
                                var m = z + b;
                                var d = y + m;
                                //print(y);
                                // print(a);
                                // print(b);
                                // print(c);
                                setState(() {
                                  _sum =
                                      TextEditingController(text: d.toStringAsFixed(2));
                                  sum = d.toString();
                                });
                                // print(sum);
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context,
                                    errorText: 'กรุณาใส่จำนวนเงิน')
                              ]),
                            ),
                          ],
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: width * 0.43,
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "อัตตราแลกเปลี่ยน",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(height: 10),
                                FormBuilderTextField(
                                  enabled: false,
                                  name: 'rate',
                                  controller: _rate,
                                  //initialValue: datasetting['rate'].toString(),
                                  decoration: InputDecoration(
                                      enabled: false,
                                      suffixIcon: Icon(
                                        Icons.monetization_on_outlined,
                                        size: 30,
                                      ),
                                      //border: InputBorder.none,
                                      border: OutlineInputBorder(),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: width * 0.43,
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ค่าบริการ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(height: 10),
                                FormBuilderTextField(
                                  enabled: false,
                                  name: 'fee',
                                  controller: _fee,
                                  decoration: InputDecoration(
                                      enabled: false,
                                      suffixIcon: Icon(
                                        Icons.monetization_on_outlined,
                                        size: 30,
                                      ),
                                      //border: InputBorder.none,
                                      border: OutlineInputBorder(),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: width * 0.43,
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "คอมมิทชั่น",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(height: 10),
                                FormBuilderTextField(
                                  enabled: false,
                                  name: 'com',
                                  controller: _com,
                                  //initialValue: datasetting['rate'].toString(),
                                  decoration: InputDecoration(
                                      enabled: false,
                                      suffixIcon: Icon(
                                        Icons.monetization_on_outlined,
                                        size: 30,
                                      ),
                                      //border: InputBorder.none,
                                      border: OutlineInputBorder(),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: width * 0.43,
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ยอดที่โอน",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(height: 10),
                                FormBuilderTextField(
                                  enabled: false,
                                  name: 'sum',
                                  controller: _sum,
                                  decoration: InputDecoration(
                                      enabled: false,
                                      suffixIcon: Icon(
                                        Icons.monetization_on_outlined,
                                        size: 30,
                                      ),
                                      //border: InputBorder.none,
                                      border: OutlineInputBorder(),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "รายละเอียด",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(height: 10),
                            FormBuilderTextField(
                              name: 'description',
                              maxLines: 4,
                              decoration: InputDecoration(
                                  //border: InputBorder.none,
                                  border: OutlineInputBorder(),
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 15),

                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //SizedBox(height: 15),
                            SizedBox(height: 15),
                            GestureDetector(
                              onTap: () {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  _formKey.currentState.save();
                                  //print(_formKey.currentState.value);
                                  _createExchange(_formKey.currentState.value);
                                } else {}
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
                      SizedBox(height: 15),
                      // GestureDetector(
                      //   onTap: (){
                      //     Navigator.push(
                      //     context, MaterialPageRoute(builder: (context) => ReceiveDetail()));
                      //   },
                      //   child: Container(
                      //     height: 50,
                      //     width: 50,
                      //     color: Colors.red,
                      //   ),
                      // ),
                      // SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(),
      ),
    );
  }

  Card buildCard(
    String id,
    String title,
    String title2,
    String title3,
    String title4,
    String date,
    String status,
    String fee,
    String name,
    String account,
    String img,
  ) {
    return Card(
      child: GestureDetector(
        onTap: () {
          var arg = {
            "id": id,
            "code": title,
            "bank": title2,
            "total": title3,
            "description": title4,
            "date": date,
            "fee": fee,
            "name": name,
            "account": account,
            "status": status,
            "img": img,
            //MyNavigator.goToTimelineOrders(context);
          };
          MyNavigator.goToReceiveDetail(context, arg);
        },
        child: ListTile(
          
          title: Row(
            children: [
              Container(
                //color: Colors.blueAccent,
                width: 100,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "เลขรายการ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "ธนาคาร",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "ยอดโอน",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "รายละเอียด",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "วันที่ทำรายการ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "สถานะ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                //color: Colors.blueAccent,
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      ":" + title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      ":" + title2,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      ":" + title3,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    title4.length <= 40
                        ? Text(
                            ":" + title4,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          )
                        : Text(
                            ":" + title4.substring(0, 60) + "...",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                    Text(
                      ":" + date,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      ":" + status,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            status == "approved" ? Colors.green : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          trailing: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_right_outlined),
              color: Colors.orange[900],
              iconSize: 30,
              onPressed: () {
                var arg = {
                  "id": id,
                  "code": title,
                  "bank": title2,
                  "total": title3,
                  "description": title4,
                  "date": date,
                  "fee": fee,
                  "name": name,
                  "account": account,
                  "status": status,
                  "img": img,
                  //MyNavigator.goToTimelineOrders(context);
                };
                MyNavigator.goToReceiveDetail(context, arg);
              },
            ),
          ]),
          /*subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  onPressed: () {
                    var arg = {
                      "id": id,
                      "code": title,
                      "bank": title2,
                      "total": title3,
                      "description": title4,
                      "date": date,
                      "fee": fee,
                      "name": name,
                      "account": account,
                      "status": status,
                      "img": img,
                    };
                    MyNavigator.goToReceiveDetail(context, arg);
                    //MyNavigator.goToTimelineOrders(context);
                    //String id,
                    // String title,
                    // String title2,
                    // String title3,
                    // String title4,
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
                )
              ],
            )*/
        ),
      ),
    );
  }

  alertTranfer(String title, String img, context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 4,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
                left: Constants.padding,
                top: Constants.avatarRadius + Constants.padding,
                right: Constants.padding,
                bottom: Constants.padding),
            margin: EdgeInsets.only(top: Constants.avatarRadius),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: kFontPrimaryColor,
                borderRadius: BorderRadius.circular(Constants.padding),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 10),
                      blurRadius: 10),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Image.asset(
                    img,
                    fit: BoxFit.cover,
                    height: 60,
                    width: 60,
                    //color: kButtonColor,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kInputSearchColor),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 33,
                ),
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: kPrimaryColor,
                  ),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "ตกลง",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kTextButtonColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
