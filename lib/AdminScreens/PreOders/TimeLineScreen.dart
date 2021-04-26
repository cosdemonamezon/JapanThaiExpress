import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/japanexpress.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter_svg/flutter_svg.dart';

const order_processed = "assets/images/order_processed.svg";
const order_confirmed = "assets/images/order_confirmed.svg";
const order_shipped = "assets/images/order_shipped.svg";
const order_onTheWay = "assets/images/on_the_way.svg";
const order_delivered = "assets/images/delivered.svg";

class TimeLineScreen extends StatefulWidget {
  // TimeLineScreen({Key key, Object argument}) : super(key: key);

  @override
  _TimeLineScreenState createState() => _TimeLineScreenState();
}

class _TimeLineScreenState extends State<TimeLineScreen> {
  SharedPreferences prefs;
  SharedPreferences prefsNoti;
  bool isLoading = false;
  Map<String, dynamic> data = {};
  List<dynamic> notidata = [];
  Map<String, dynamic> readnotidata = {};
  Map<String, dynamic> dataTimeline = {};
  String id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routeArgs1 =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      id = routeArgs1['id'];
      print(id);
      _gettimeline(id);
    });
  }

  _gettimeline(String id) async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(pathAPI + 'api/preorder/' + id);
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token['data']['token']
      },
    );
    if (response.statusCode == 200) {
      //print(response.statusCode);
      final Map<String, dynamic> data = convert.jsonDecode(response.body);
      //print(notinumber);
      if (data['code'] == 200) {
        setState(() {
          dataTimeline = data;
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
        elevation: 0,
        centerTitle: true,
        title: Text("สถานะรายการ"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
              height: 110,
              width: MediaQuery.of(context).size.width - 20,
              //color: Colors.red,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Text(
                          "ฝากซื้อสินค้า",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: kFontPrimaryColor),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              dataTimeline.length > 0
                                  ? dataTimeline['data']['name']
                                  : 0,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: kFontPrimaryColor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              dataTimeline.length > 0
                                  ? dataTimeline['data']['qty'] + " รายการ"
                                  : 0,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  color: kFontPrimaryColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Column(
                        children: [
                          Icon(
                            Icons.support_agent,
                            color: primaryColor,
                            size: 45,
                          ),
                          Text(
                            "ร้านค้า",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.supervised_user_circle,
                            color: primaryColor,
                            size: 45,
                          ),
                          Text(
                            "ลูกค้า",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            _divider(),
            TimelineTile(
              topLineStyle: LineStyle(color: Colors.red),
              bottomLineStyle: LineStyle(
                  color: dataTimeline.length > 0
                      ? dataTimeline['data']['step'] == "order" ||
                              dataTimeline['data']['step'] == "payment" ||
                              dataTimeline['data']['step'] == "buy" ||
                              dataTimeline['data']['step'] == "shipping" ||
                              dataTimeline['data']['step'] == "store_japan" ||
                              dataTimeline['data']['step'] == "transport" ||
                              dataTimeline['data']['step'] == "store_thai" ||
                              dataTimeline['data']['step'] == "overdue" ||
                              dataTimeline['data']['step'] == "delivery"
                          ? Colors.red
                          : Colors.black54
                      : Colors.black54),
              alignment: TimelineAlign.center,
              isFirst: true,
              indicatorStyle: IndicatorStyle(
                width: 20,
                color: dataTimeline.length > 0
                    ? dataTimeline['data']['step'] == "new" ||
                            dataTimeline['data']['step'] == "order" ||
                            dataTimeline['data']['step'] == "payment" ||
                            dataTimeline['data']['step'] == "buy" ||
                            dataTimeline['data']['step'] == "shipping" ||
                            dataTimeline['data']['step'] == "store_japan" ||
                            dataTimeline['data']['step'] == "transport" ||
                            dataTimeline['data']['step'] == "store_thai" ||
                            dataTimeline['data']['step'] == "overdue" ||
                            dataTimeline['data']['step'] == "delivery"
                        ? Colors.red
                        : Colors.black54
                    : Colors.black54,
                indicatorY: 0.2,
                padding: EdgeInsets.all(8),
              ),
              rightChild: Container(
                child: Column(
                  children: [
                    Icon(
                      Icons.directions_boat,
                      color: dataTimeline.length > 0
                          ? dataTimeline['data']['step'] == "new" ||
                                  dataTimeline['data']['step'] == "order" ||
                                  dataTimeline['data']['step'] == "payment" ||
                                  dataTimeline['data']['step'] == "buy" ||
                                  dataTimeline['data']['step'] == "shipping" ||
                                  dataTimeline['data']['step'] ==
                                      "store_japan" ||
                                  dataTimeline['data']['step'] == "transport" ||
                                  dataTimeline['data']['step'] ==
                                      "store_thai" ||
                                  dataTimeline['data']['step'] == "overdue" ||
                                  dataTimeline['data']['step'] == "delivery"
                              ? primaryColor
                              : Colors.black54
                          : Colors.black54,
                      size: 45,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "New Order",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "we are preparing your order",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
            TimelineTile(
              topLineStyle: LineStyle(
                  color: dataTimeline.length > 0
                      ? dataTimeline['data']['step'] == "order" ||
                              dataTimeline['data']['step'] == "payment" ||
                              dataTimeline['data']['step'] == "buy" ||
                              dataTimeline['data']['step'] == "shipping" ||
                              dataTimeline['data']['step'] == "store_japan" ||
                              dataTimeline['data']['step'] == "transport" ||
                              dataTimeline['data']['step'] == "store_thai" ||
                              dataTimeline['data']['step'] == "overdue" ||
                              dataTimeline['data']['step'] == "delivery"
                          ? Colors.red
                          : Colors.black54
                      : Colors.black54),
              bottomLineStyle: LineStyle(
                  color: dataTimeline.length > 0
                      ? dataTimeline['data']['step'] == "payment" ||
                              dataTimeline['data']['step'] == "buy" ||
                              dataTimeline['data']['step'] == "shipping" ||
                              dataTimeline['data']['step'] == "store_japan" ||
                              dataTimeline['data']['step'] == "transport" ||
                              dataTimeline['data']['step'] == "store_thai" ||
                              dataTimeline['data']['step'] == "overdue" ||
                              dataTimeline['data']['step'] == "delivery"
                          ? Colors.red
                          : Colors.black54
                      : Colors.black54),
              alignment: TimelineAlign.center,
              indicatorStyle: IndicatorStyle(
                width: 20,
                color: dataTimeline.length > 0
                    ? dataTimeline['data']['step'] == "order" ||
                            dataTimeline['data']['step'] == "payment" ||
                            dataTimeline['data']['step'] == "buy" ||
                            dataTimeline['data']['step'] == "shipping" ||
                            dataTimeline['data']['step'] == "store_japan" ||
                            dataTimeline['data']['step'] == "transport" ||
                            dataTimeline['data']['step'] == "store_thai" ||
                            dataTimeline['data']['step'] == "overdue" ||
                            dataTimeline['data']['step'] == "delivery"
                        ? Colors.red
                        : Colors.black54
                    : Colors.black54,
                padding: EdgeInsets.all(8),
                indicatorY: 0.3,
              ),
              leftChild: Container(
                child: Column(
                  children: [
                    Icon(
                      Icons.directions_boat,
                      color: dataTimeline.length > 0
                          ? dataTimeline['data']['step'] == "order" ||
                                  dataTimeline['data']['step'] == "payment" ||
                                  dataTimeline['data']['step'] == "buy" ||
                                  dataTimeline['data']['step'] == "shipping" ||
                                  dataTimeline['data']['step'] ==
                                      "store_japan" ||
                                  dataTimeline['data']['step'] == "transport" ||
                                  dataTimeline['data']['step'] ==
                                      "store_thai" ||
                                  dataTimeline['data']['step'] == "overdue" ||
                                  dataTimeline['data']['step'] == "delivery"
                              ? primaryColor
                              : Colors.black54
                          : Colors.black54,
                      size: 45,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Order Confirmed",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "order has been confirmed",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
            TimelineTile(
              topLineStyle: LineStyle(
                  color: dataTimeline.length > 0
                      ? dataTimeline['data']['step'] == "payment" ||
                              dataTimeline['data']['step'] == "buy" ||
                              dataTimeline['data']['step'] == "shipping" ||
                              dataTimeline['data']['step'] == "store_japan" ||
                              dataTimeline['data']['step'] == "transport" ||
                              dataTimeline['data']['step'] == "store_thai" ||
                              dataTimeline['data']['step'] == "overdue" ||
                              dataTimeline['data']['step'] == "delivery"
                          ? Colors.red
                          : Colors.black54
                      : Colors.black54),
              bottomLineStyle: LineStyle(
                  color: dataTimeline.length > 0
                      ? dataTimeline['data']['step'] == "buy" ||
                              dataTimeline['data']['step'] == "shipping" ||
                              dataTimeline['data']['step'] == "store_japan" ||
                              dataTimeline['data']['step'] == "transport" ||
                              dataTimeline['data']['step'] == "store_thai" ||
                              dataTimeline['data']['step'] == "overdue" ||
                              dataTimeline['data']['step'] == "delivery"
                          ? Colors.red
                          : Colors.black54
                      : Colors.black54),
              alignment: TimelineAlign.center,
              indicatorStyle: IndicatorStyle(
                width: 20,
                color: dataTimeline.length > 0
                    ? dataTimeline['data']['step'] == "payment" ||
                            dataTimeline['data']['step'] == "buy" ||
                            dataTimeline['data']['step'] == "shipping" ||
                            dataTimeline['data']['step'] == "store_japan" ||
                            dataTimeline['data']['step'] == "transport" ||
                            dataTimeline['data']['step'] == "store_thai" ||
                            dataTimeline['data']['step'] == "overdue" ||
                            dataTimeline['data']['step'] == "delivery"
                        ? Colors.red
                        : Colors.black54
                    : Colors.black54,
                padding: EdgeInsets.all(8),
                indicatorY: 0.3,
              ),
              rightChild: Container(
                child: Column(
                  children: [
                    Icon(
                      Icons.directions_boat,
                      color: dataTimeline.length > 0
                          ? dataTimeline['data']['step'] == "payment" ||
                                  dataTimeline['data']['step'] == "buy" ||
                                  dataTimeline['data']['step'] == "shipping" ||
                                  dataTimeline['data']['step'] ==
                                      "store_japan" ||
                                  dataTimeline['data']['step'] == "transport" ||
                                  dataTimeline['data']['step'] ==
                                      "store_thai" ||
                                  dataTimeline['data']['step'] == "overdue" ||
                                  dataTimeline['data']['step'] == "delivery"
                              ? primaryColor
                              : Colors.black54
                          : Colors.black54,
                      size: 45,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Payment",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "order has been confirmed",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
            TimelineTile(
              topLineStyle: LineStyle(
                  color: dataTimeline.length > 0
                      ? dataTimeline['data']['step'] == "buy" ||
                              dataTimeline['data']['step'] == "shipping" ||
                              dataTimeline['data']['step'] == "store_japan" ||
                              dataTimeline['data']['step'] == "transport" ||
                              dataTimeline['data']['step'] == "store_thai" ||
                              dataTimeline['data']['step'] == "overdue" ||
                              dataTimeline['data']['step'] == "delivery"
                          ? Colors.red
                          : Colors.black54
                      : Colors.black54),
              bottomLineStyle: LineStyle(
                  color: dataTimeline.length > 0
                      ? dataTimeline['data']['step'] == "shipping" ||
                              dataTimeline['data']['step'] == "store_japan" ||
                              dataTimeline['data']['step'] == "transport" ||
                              dataTimeline['data']['step'] == "store_thai" ||
                              dataTimeline['data']['step'] == "overdue" ||
                              dataTimeline['data']['step'] == "delivery"
                          ? Colors.red
                          : Colors.black54
                      : Colors.black54),
              alignment: TimelineAlign.center,
              indicatorStyle: IndicatorStyle(
                width: 20,
                color: dataTimeline.length > 0
                    ? dataTimeline['data']['step'] == "buy" ||
                            dataTimeline['data']['step'] == "shipping" ||
                            dataTimeline['data']['step'] == "store_japan" ||
                            dataTimeline['data']['step'] == "transport" ||
                            dataTimeline['data']['step'] == "store_thai" ||
                            dataTimeline['data']['step'] == "overdue" ||
                            dataTimeline['data']['step'] == "delivery"
                        ? Colors.red
                        : Colors.black54
                    : Colors.black54,
                padding: EdgeInsets.all(8),
                indicatorY: 0.3,
              ),
              leftChild: Container(
                child: Column(
                  children: [
                    Icon(
                      Icons.directions_boat,
                      color: dataTimeline.length > 0
                          ? dataTimeline['data']['step'] == "buy" ||
                                  dataTimeline['data']['step'] == "shipping" ||
                                  dataTimeline['data']['step'] ==
                                      "store_japan" ||
                                  dataTimeline['data']['step'] == "transport" ||
                                  dataTimeline['data']['step'] ==
                                      "store_thai" ||
                                  dataTimeline['data']['step'] == "overdue" ||
                                  dataTimeline['data']['step'] == "delivery"
                              ? primaryColor
                              : Colors.black54
                          : Colors.black54,
                      size: 45,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Production order",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "order has been confirmed",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
            TimelineTile(
              topLineStyle: LineStyle(
                  color: dataTimeline.length > 0
                      ? dataTimeline['data']['step'] == "shipping" ||
                              dataTimeline['data']['step'] == "store_japan" ||
                              dataTimeline['data']['step'] == "transport" ||
                              dataTimeline['data']['step'] == "store_thai" ||
                              dataTimeline['data']['step'] == "overdue" ||
                              dataTimeline['data']['step'] == "delivery"
                          ? Colors.red
                          : Colors.black54
                      : Colors.black54),
              bottomLineStyle: LineStyle(
                  color: dataTimeline.length > 0
                      ? dataTimeline['data']['step'] == "store_japan" ||
                              dataTimeline['data']['step'] == "transport" ||
                              dataTimeline['data']['step'] == "store_thai" ||
                              dataTimeline['data']['step'] == "overdue" ||
                              dataTimeline['data']['step'] == "delivery"
                          ? Colors.red
                          : Colors.black54
                      : Colors.black54),
              alignment: TimelineAlign.center,
              indicatorStyle: IndicatorStyle(
                width: 20,
                color: dataTimeline.length > 0
                    ? dataTimeline['data']['step'] == "shipping" ||
                            dataTimeline['data']['step'] == "store_japan" ||
                            dataTimeline['data']['step'] == "transport" ||
                            dataTimeline['data']['step'] == "store_thai" ||
                            dataTimeline['data']['step'] == "overdue" ||
                            dataTimeline['data']['step'] == "delivery"
                        ? Colors.red
                        : Colors.black54
                    : Colors.black54,
                padding: EdgeInsets.all(8),
                indicatorY: 0.3,
              ),
              leftChild: Container(
                child: Column(
                  children: [
                    Icon(
                      Icons.directions_boat,
                      color: dataTimeline.length > 0
                          ? dataTimeline['data']['step'] == "shipping" ||
                                  dataTimeline['data']['step'] ==
                                      "store_japan" ||
                                  dataTimeline['data']['step'] == "transport" ||
                                  dataTimeline['data']['step'] ==
                                      "store_thai" ||
                                  dataTimeline['data']['step'] == "overdue" ||
                                  dataTimeline['data']['step'] == "delivery"
                              ? primaryColor
                              : Colors.black54
                          : Colors.black54,
                      size: 45,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Shipping",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "order has been confirmed",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
            TimelineTile(
              topLineStyle: LineStyle(
                  color: dataTimeline.length > 0
                      ? dataTimeline['data']['step'] == "store_japan" ||
                              dataTimeline['data']['step'] == "transport" ||
                              dataTimeline['data']['step'] == "store_thai" ||
                              dataTimeline['data']['step'] == "overdue" ||
                              dataTimeline['data']['step'] == "delivery"
                          ? Colors.red
                          : Colors.black54
                      : Colors.black54),
              bottomLineStyle: LineStyle(
                  color: dataTimeline.length > 0
                      ? dataTimeline['data']['step'] == "transport" ||
                              dataTimeline['data']['step'] == "store_thai" ||
                              dataTimeline['data']['step'] == "overdue" ||
                              dataTimeline['data']['step'] == "delivery"
                          ? Colors.red
                          : Colors.black54
                      : Colors.black54),
              alignment: TimelineAlign.center,
              indicatorStyle: IndicatorStyle(
                width: 20,
                color: dataTimeline.length > 0
                    ? dataTimeline['data']['step'] == "store_japan" ||
                            dataTimeline['data']['step'] == "transport" ||
                            dataTimeline['data']['step'] == "store_thai" ||
                            dataTimeline['data']['step'] == "overdue" ||
                            dataTimeline['data']['step'] == "delivery"
                        ? Colors.red
                        : Colors.black54
                    : Colors.black54,
                padding: EdgeInsets.all(8),
                indicatorY: 0.3,
              ),
              leftChild: Container(
                child: Column(
                  children: [
                    Icon(
                      Icons.directions_boat,
                      color: dataTimeline.length > 0
                          ? dataTimeline['data']['step'] == "store_japan" ||
                                  dataTimeline['data']['step'] == "transport" ||
                                  dataTimeline['data']['step'] ==
                                      "store_thai" ||
                                  dataTimeline['data']['step'] == "overdue" ||
                                  dataTimeline['data']['step'] == "delivery"
                              ? primaryColor
                              : Colors.black54
                          : Colors.black54,
                      size: 45,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Store on Japan",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "order has been confirmed",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
            TimelineTile(
              topLineStyle: LineStyle(
                  color: dataTimeline.length > 0
                      ? dataTimeline['data']['step'] == "transport" ||
                              dataTimeline['data']['step'] == "store_thai" ||
                              dataTimeline['data']['step'] == "overdue" ||
                              dataTimeline['data']['step'] == "delivery"
                          ? Colors.red
                          : Colors.black54
                      : Colors.black54),
              bottomLineStyle: LineStyle(
                  color: dataTimeline.length > 0
                      ? dataTimeline['data']['step'] == "store_thai" ||
                              dataTimeline['data']['step'] == "overdue" ||
                              dataTimeline['data']['step'] == "delivery"
                          ? Colors.red
                          : Colors.black54
                      : Colors.black54),
              alignment: TimelineAlign.center,
              indicatorStyle: IndicatorStyle(
                width: 20,
                color: dataTimeline.length > 0
                    ? dataTimeline['data']['step'] == "transport" ||
                            dataTimeline['data']['step'] == "store_thai" ||
                            dataTimeline['data']['step'] == "overdue" ||
                            dataTimeline['data']['step'] == "delivery"
                        ? Colors.red
                        : Colors.black54
                    : Colors.black54,
                padding: EdgeInsets.all(8),
                indicatorY: 0.3,
              ),
              leftChild: Container(
                child: Column(
                  children: [
                    Icon(
                      Icons.directions_boat,
                      color: dataTimeline.length > 0
                          ? dataTimeline['data']['step'] == "transport" ||
                                  dataTimeline['data']['step'] ==
                                      "store_thai" ||
                                  dataTimeline['data']['step'] == "overdue" ||
                                  dataTimeline['data']['step'] == "delivery"
                              ? primaryColor
                              : Colors.black54
                          : Colors.black54,
                      size: 45,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Transport",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "order has been confirmed",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
            TimelineTile(
              topLineStyle: LineStyle(
                  color: dataTimeline.length > 0
                      ? dataTimeline['data']['step'] == "store_thai" ||
                              dataTimeline['data']['step'] == "overdue" ||
                              dataTimeline['data']['step'] == "delivery"
                          ? Colors.red
                          : Colors.black54
                      : Colors.black54),
              bottomLineStyle: LineStyle(
                  color: dataTimeline.length > 0
                      ? dataTimeline['data']['step'] == "overdue" ||
                              dataTimeline['data']['step'] == "delivery"
                          ? Colors.red
                          : Colors.black54
                      : Colors.black54),
              alignment: TimelineAlign.center,
              indicatorStyle: IndicatorStyle(
                width: 20,
                color: dataTimeline.length > 0
                    ? dataTimeline['data']['step'] == "store_thai" ||
                            dataTimeline['data']['step'] == "overdue" ||
                            dataTimeline['data']['step'] == "delivery"
                        ? Colors.red
                        : Colors.black54
                    : Colors.black54,
                padding: EdgeInsets.all(8),
                indicatorY: 0.3,
              ),
              leftChild: Container(
                child: Column(
                  children: [
                    Icon(
                      Icons.directions_boat,
                      color: dataTimeline.length > 0
                          ? dataTimeline['data']['step'] == "store_thai" ||
                                  dataTimeline['data']['step'] == "overdue" ||
                                  dataTimeline['data']['step'] == "delivery"
                              ? primaryColor
                              : Colors.black54
                          : Colors.black54,
                      size: 45,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Store Thailand",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "order has been confirmed",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
            TimelineTile(
              topLineStyle: LineStyle(
                  color: dataTimeline.length > 0
                      ? dataTimeline['data']['step'] == "overdue" ||
                              dataTimeline['data']['step'] == "delivery"
                          ? primaryColor
                          : Colors.black54
                      : Colors.black54),
              bottomLineStyle: LineStyle(
                  color: dataTimeline.length > 0
                      ? dataTimeline['data']['step'] == "delivery"
                          ? primaryColor
                          : Colors.black54
                      : Colors.black54),
              alignment: TimelineAlign.center,
              indicatorStyle: IndicatorStyle(
                width: 20,
                color: dataTimeline.length > 0
                    ? dataTimeline['data']['step'] == "overdue" ||
                            dataTimeline['data']['step'] == "delivery"
                        ? Colors.red
                        : Colors.black54
                    : Colors.black54,
                padding: EdgeInsets.all(8),
                indicatorY: 0.3,
              ),
              rightChild: Container(
                child: Column(
                  children: [
                    Icon(
                      Icons.directions_boat,
                      color: dataTimeline.length > 0
                          ? dataTimeline['data']['step'] == "overdue" ||
                                  dataTimeline['data']['step'] == "delivery"
                              ? primaryColor
                              : Colors.black54
                          : Colors.black54,
                      size: 45,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Overdue",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "order has been confirmed",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
            TimelineTile(
              topLineStyle: LineStyle(
                  color: dataTimeline.length > 0
                      ? dataTimeline['data']['step'] == "delivery"
                          ? Colors.red
                          : Colors.black54
                      : Colors.black54),
              bottomLineStyle: LineStyle(
                  color: dataTimeline.length > 0
                      ? dataTimeline['data']['step'] == "delivery"
                          ? Colors.red
                          : Colors.black54
                      : Colors.black54),
              alignment: TimelineAlign.center,
              indicatorStyle: IndicatorStyle(
                width: 20,
                color: dataTimeline.length > 0
                    ? dataTimeline['data']['step'] == "delivery"
                        ? Colors.red
                        : Colors.black54
                    : Colors.black54,
                padding: EdgeInsets.all(8),
                indicatorY: 0.3,
              ),
              leftChild: Container(
                child: Column(
                  children: [
                    Icon(
                      Icons.directions_boat,
                      color: dataTimeline.length > 0
                          ? dataTimeline['data']['step'] == "delivery"
                              ? primaryColor
                              : Colors.black54
                          : Colors.black54,
                      size: 45,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Derivered",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "order has been confirmed",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navigation(),
    );
  }

  _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
                color: primaryColor,
              ),
            ),
          ),
          // Text('or'),
          // Expanded(
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 10),
          //     child: Divider(
          //       thickness: 1,
          //       color: primaryColor,
          //     ),
          //   ),
          // ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}
