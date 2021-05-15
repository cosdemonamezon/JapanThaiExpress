import 'package:JapanThaiExpress/AdminScreens/Depository/DepositoryScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/japanexpress.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../utils/my_navigator.dart';

const order_processed = "assets/images/order_processed.svg";
const order_confirmed = "assets/images/order_confirmed.svg";
const order_shipped = "assets/images/order_shipped.svg";
const order_onTheWay = "assets/images/on_the_way.svg";
const order_delivered = "assets/images/delivered.svg";

class TimeLineDepository extends StatefulWidget {
  // TimeLineDepository({Key key, Object argument}) : super(key: key);

  @override
  _TimeLineDepositoryState createState() => _TimeLineDepositoryState();
}

class _TimeLineDepositoryState extends State<TimeLineDepository> {
  SharedPreferences prefs;
  SharedPreferences prefsNoti;
  bool isLoading = false;
  Map<String, dynamic> data = {};
  List<dynamic> notidata = [];
  Map<String, dynamic> readnotidata = {};
  Map<String, dynamic> dataTimeline = {};
  String id;

  List<String> familyMemberName = [];
  List<String> familyMemberLabel = [];
  List<String> familyMemberField = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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
    // var url = pathAPI + 'api/preorder/' + id;
    var url = Uri.parse(pathAPI + 'api/get_detail_depository');
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token['data']['token']
        },
        body: convert.jsonEncode({
          'depository_id': id,
        }));
    if (response.statusCode == 200) {
      //print(response.statusCode);
      final Map<String, dynamic> data = convert.jsonDecode(response.body);
      // print(notinumber);
      var Data = convert.jsonDecode(response.body);
      int index = 0;
      if (Data["data"]["step"] == 'new') {
        index = 0;
      } else if (Data["data"]["step"] == 'order') {
        index = 1;
      } else if (Data["data"]["step"] == 'track') {
        index = 2;
      } else if (Data["data"]["step"] == 'transport') {
        index = 3;
      } else if (Data["data"]["step"] == 'store_thai') {
        index = 4;
      } else if (Data["data"]["step"] == 'overdue') {
        index = 5;
      } else if (Data["data"]["step"] == 'delivery') {
        index = 6;
      }
      var familyMembers = Data["data"]["list"][index]["field"];
      for (var familyMember in familyMembers) {
        if (familyMember["name"] != 'status') {
          setState(() {
            familyMemberLabel.add(familyMember["label"]);
            // var textEditingController = TextEditingController();
            familyMemberName.add(familyMember["name"]);
            familyMemberField.add(familyMember["name"]);
          });
          print(familyMemberName);
        }
      }
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

  dialogTimeline(String title, String img, context, List label, List name,
      int id, String step, List field) {
    String stepUp;
    if (step == 'new') {
      stepUp = 'order';
    } else if (step == 'order') {
      stepUp = 'track';
    } else if (step == 'track') {
      stepUp = 'transport';
    } else if (step == 'transport') {
      stepUp = 'store_thai';
    } else if (step == 'store_thai') {
      stepUp = 'overdue';
    } else if (step == 'overdue') {
      stepUp = 'delivery';
    }
    // List<int> text = [1, 2, 3, 4];
    final _formKey = GlobalKey<FormBuilderState>();
    return AlertDialog(
        content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FormBuilder(
              key: _formKey,
              child: Column(children: <Widget>[
                Text("อัพเดทสถานะรายการ"),
                SizedBox(height: 7),
                for (var i = 0; i <= label.length - 1; i++)
                  Column(
                    children: [
                      FormBuilderTextField(
                        name: name[i],
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: label[i].toString(),
                            //border: InputBorder.none,
                            border: OutlineInputBorder(),
                            fillColor: Color(0xfff3f3f4),
                            filled: true),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText: 'กรุณากรอกข้อมูล'),
                          // FormBuilderValidators.numeric(context),
                          // FormBuilderValidators.max(context, 70),
                        ]),
                      ),
                      // TextFormField(
                      //   autofocus: true,
                      //   decoration: InputDecoration(
                      //       //border: InputBorder.none,
                      //       hintText: label[i].toString(),
                      //       border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(10.0)),
                      //       fillColor: Color(0xfff3f3f4),
                      //       filled: true),
                      // ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            setStep(_formKey.currentState.value, name, id,
                                context, stepUp, 'pending', field);
                          } else {
                            print("no data");
                          }
                        },
                        padding: EdgeInsets.all(7),
                        color: Colors.red,
                        child: Text('อนุมัติรายการ',
                            style:
                                TextStyle(color: Colors.white, fontSize: 13)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        onPressed: () {
                          if (stepUp != 'order') {
                            Navigator.pop(context);
                          } else {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              setStep(_formKey.currentState.value, name, id,
                                  context, stepUp, 'rejected', field);
                            } else {
                              print("no data");
                            }
                          }
                        },
                        padding: EdgeInsets.all(7),
                        color: Colors.black54,
                        child: Text(
                            stepUp != 'order' ? 'ปิดหน้านี้' : 'ยกเลิกรายการ',
                            style:
                                TextStyle(color: Colors.white, fontSize: 13)),
                      ),
                    ),
                  ],
                ),
              ]),
            )));
  }

  setStep(Map<String, dynamic> values, List name, int id, context,
      String setStep, String status, List field) async {
    //print(values);
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var url = Uri.parse(pathAPI + 'api/appove_depository/' + id.toString());
    var response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token['data']['token']
        },
        body: convert.jsonEncode({
          for (var i = 0; i <= name.length - 1; i++)
            field[i]: values[field[i]].toString(),
          'status': status,
          'step': setStep,
        }));
    if (response.statusCode == 201) {
      setState(() {
        isLoading = true;
      });
      // Navigator.pop(context);
      _gettimeline(id.toString());
      // MyNavigator.goToTimelineDepository(context, id);
    } else {
      setState(() {
        isLoading = true;
      });
      // Navigator.pop(context);
      _gettimeline(id.toString());
      // MyNavigator.goToTimelineDepository(context, id);
    }
    Navigator.pop(context);
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _gettimeline(id); //ทุกครั้งที่ทำการรีเฟรช จะดึงข้อมูลใหม่
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("สถานะรายการ"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DepositoryScreen()));
            }),
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SmartRefresher(
              enablePullDown: true,
              enablePullUp: false,
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
              // onLoading: _onRefresh,
              child: SingleChildScrollView(
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
                                  "ฝากส่งสินค้า" + " No.",
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
                                          ? dataTimeline['data']['description']
                                          : " - ",
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
                                    padding: const EdgeInsets.only(right: 0),
                                    child: Text(
                                      "1 รายการ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          color: kFontPrimaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
                              ? dataTimeline['data']['step'] == "new" ||
                                      dataTimeline['data']['step'] == "order" ||
                                      dataTimeline['data']['step'] == "track" ||
                                      dataTimeline['data']['step'] ==
                                          "transport" ||
                                      dataTimeline['data']['step'] ==
                                          "store_thai" ||
                                      dataTimeline['data']['step'] ==
                                          "overdue" ||
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
                                    dataTimeline['data']['step'] == "track" ||
                                    dataTimeline['data']['step'] ==
                                        "transport" ||
                                    dataTimeline['data']['step'] ==
                                        "store_thai" ||
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
                            Stack(children: <Widget>[
                              GestureDetector(
                                onTap: () {},
                                child: Icon(
                                  Icons.directions_boat,
                                  color: dataTimeline.length > 0
                                      ? dataTimeline['data']['step'] == "new" ||
                                              dataTimeline['data']['step'] ==
                                                  "order" ||
                                              dataTimeline['data']['step'] ==
                                                  "track" ||
                                              dataTimeline['data']['step'] ==
                                                  "transport" ||
                                              dataTimeline['data']['step'] ==
                                                  "store_thai" ||
                                              dataTimeline['data']['step'] ==
                                                  "overdue" ||
                                              dataTimeline['data']['step'] ==
                                                  "delivery"
                                          ? primaryColor
                                          : Colors.black54
                                      : Colors.black54,
                                  size: 45,
                                ),
                              ),
                              dataTimeline.length > 0
                                  ? dataTimeline['data']['step'] == ""
                                      ? Positioned(
                                          // draw a red marble
                                          top: 10.0,
                                          right: 10.0,
                                          child: Icon(Icons.touch_app,
                                              size: 25.0,
                                              color: Colors.yellowAccent),
                                        )
                                      : SizedBox(
                                          height: 0,
                                        )
                                  : SizedBox(
                                      height: 0,
                                    ),
                            ]),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "สร้างรายการ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TimelineTile(
                      topLineStyle: LineStyle(color: Colors.red),
                      bottomLineStyle: LineStyle(
                          color: dataTimeline.length > 0
                              ? dataTimeline['data']['step'] == "order" ||
                                      dataTimeline['data']['step'] == "track" ||
                                      dataTimeline['data']['step'] ==
                                          "transport" ||
                                      dataTimeline['data']['step'] ==
                                          "store_thai" ||
                                      dataTimeline['data']['step'] ==
                                          "overdue" ||
                                      dataTimeline['data']['step'] == "delivery"
                                  ? Colors.red
                                  : Colors.black54
                              : Colors.black54),
                      alignment: TimelineAlign.center,
                      isFirst: true,
                      indicatorStyle: IndicatorStyle(
                        width: 20,
                        color: dataTimeline.length > 0
                            ? dataTimeline['data']['step'] == "order" ||
                                    dataTimeline['data']['step'] == "track" ||
                                    dataTimeline['data']['step'] ==
                                        "transport" ||
                                    dataTimeline['data']['step'] ==
                                        "store_thai" ||
                                    dataTimeline['data']['step'] == "overdue" ||
                                    dataTimeline['data']['step'] == "delivery"
                                ? Colors.red
                                : Colors.black54
                            : Colors.black54,
                        indicatorY: 0.2,
                        padding: EdgeInsets.all(8),
                      ),
                      leftChild: Container(
                        child: GestureDetector(
                          onTap: () {
                            if (dataTimeline.length > 0 &&
                                dataTimeline['data']['step'] == "new" &&
                                dataTimeline['data']['list'][0]['show'] ==
                                    true) {
                              String title = "";
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => dialogTimeline(
                                    title,
                                    picDenied,
                                    context,
                                    familyMemberLabel,
                                    familyMemberName,
                                    dataTimeline['data']['id'],
                                    dataTimeline.length > 0
                                        ? dataTimeline['data']['step']
                                        : 'new',
                                    familyMemberField),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              Stack(children: <Widget>[
                                Icon(
                                  Icons.directions_boat,
                                  color: dataTimeline.length > 0
                                      ? dataTimeline['data']['step'] ==
                                                  "order" ||
                                              dataTimeline['data']['step'] ==
                                                  "track" ||
                                              dataTimeline['data']['step'] ==
                                                  "transport" ||
                                              dataTimeline['data']['step'] ==
                                                  "store_thai" ||
                                              dataTimeline['data']['step'] ==
                                                  "overdue" ||
                                              dataTimeline['data']['step'] ==
                                                  "delivery"
                                          ? primaryColor
                                          : Colors.black54
                                      : Colors.black54,
                                  size: 45,
                                ),
                                dataTimeline.length > 0
                                    ? dataTimeline['data']['step'] == "new"
                                        ? Positioned(
                                            // draw a red marble
                                            top: 10.0,
                                            right: 10.0,
                                            child: Icon(Icons.touch_app,
                                                size: 25.0,
                                                color: Colors.yellowAccent),
                                          )
                                        : SizedBox(
                                            height: 0,
                                          )
                                    : SizedBox(
                                        height: 0,
                                      ),
                              ]),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "ยืนยันรายการ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TimelineTile(
                      topLineStyle: LineStyle(color: Colors.red),
                      bottomLineStyle: LineStyle(
                          color: dataTimeline.length > 0
                              ? dataTimeline['data']['step'] == "track" ||
                                      dataTimeline['data']['step'] ==
                                          "transport" ||
                                      dataTimeline['data']['step'] ==
                                          "store_thai" ||
                                      dataTimeline['data']['step'] ==
                                          "overdue" ||
                                      dataTimeline['data']['step'] == "delivery"
                                  ? Colors.red
                                  : Colors.black54
                              : Colors.black54),
                      alignment: TimelineAlign.center,
                      isFirst: true,
                      indicatorStyle: IndicatorStyle(
                        width: 20,
                        color: dataTimeline.length > 0
                            ? dataTimeline['data']['step'] == "order" ||
                                    dataTimeline['data']['step'] == "track" ||
                                    dataTimeline['data']['step'] ==
                                        "transport" ||
                                    dataTimeline['data']['step'] ==
                                        "store_thai" ||
                                    dataTimeline['data']['step'] == "overdue" ||
                                    dataTimeline['data']['step'] == "delivery"
                                ? Colors.red
                                : Colors.black54
                            : Colors.black54,
                        indicatorY: 0.2,
                        padding: EdgeInsets.all(8),
                      ),
                      leftChild: Container(
                        child: GestureDetector(
                          onTap: () {
                            if (dataTimeline.length > 0 &&
                                dataTimeline['data']['step'] == "order" &&
                                dataTimeline['data']['list'][1]['show'] ==
                                    true) {
                              String title = "";
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => dialogTimeline(
                                    title,
                                    picDenied,
                                    context,
                                    familyMemberLabel,
                                    familyMemberName,
                                    dataTimeline['data']['id'],
                                    dataTimeline.length > 0
                                        ? dataTimeline['data']['step']
                                        : 'track',
                                    familyMemberField),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              Stack(children: <Widget>[
                                Icon(
                                  Icons.directions_boat,
                                  color: dataTimeline.length > 0
                                      ? dataTimeline['data']['step'] ==
                                                  "track" ||
                                              dataTimeline['data']['step'] ==
                                                  "transport" ||
                                              dataTimeline['data']['step'] ==
                                                  "store_thai" ||
                                              dataTimeline['data']['step'] ==
                                                  "overdue" ||
                                              dataTimeline['data']['step'] ==
                                                  "delivery"
                                          ? primaryColor
                                          : Colors.black54
                                      : Colors.black54,
                                  size: 45,
                                ),
                                dataTimeline.length > 0
                                    ? dataTimeline['data']['step'] == "order"
                                        ? Positioned(
                                            // draw a red marble
                                            top: 10.0,
                                            right: 10.0,
                                            child: Icon(Icons.touch_app,
                                                size: 25.0,
                                                color: Colors.yellowAccent),
                                          )
                                        : SizedBox(
                                            height: 0,
                                          )
                                    : SizedBox(
                                        height: 0,
                                      ),
                              ]),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "รอจัดส่ง",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TimelineTile(
                      topLineStyle: LineStyle(color: Colors.red),
                      bottomLineStyle: LineStyle(
                          color: dataTimeline.length > 0
                              ? dataTimeline['data']['step'] == "transport" ||
                                      dataTimeline['data']['step'] ==
                                          "store_thai" ||
                                      dataTimeline['data']['step'] ==
                                          "overdue" ||
                                      dataTimeline['data']['step'] == "delivery"
                                  ? Colors.red
                                  : Colors.black54
                              : Colors.black54),
                      alignment: TimelineAlign.center,
                      isFirst: true,
                      indicatorStyle: IndicatorStyle(
                        width: 20,
                        color: dataTimeline.length > 0
                            ? dataTimeline['data']['step'] == "store_thai" ||
                                    dataTimeline['data']['step'] ==
                                        "transport" ||
                                    dataTimeline['data']['step'] == "overdue" ||
                                    dataTimeline['data']['step'] == "delivery"
                                ? Colors.red
                                : Colors.black54
                            : Colors.black54,
                        indicatorY: 0.2,
                        padding: EdgeInsets.all(8),
                      ),
                      rightChild: Container(
                        child: GestureDetector(
                          onTap: () {
                            if (dataTimeline.length > 0 &&
                                dataTimeline['data']['step'] == "transport" &&
                                dataTimeline['data']['list'][3]['show'] ==
                                    true) {
                              String title = "";
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => dialogTimeline(
                                    title,
                                    picDenied,
                                    context,
                                    familyMemberLabel,
                                    familyMemberName,
                                    dataTimeline['data']['id'],
                                    dataTimeline.length > 0
                                        ? dataTimeline['data']['step']
                                        : 'transport',
                                    familyMemberField),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              Stack(children: <Widget>[
                                Icon(
                                  Icons.directions_boat,
                                  color: dataTimeline.length > 0
                                      ? dataTimeline['data']['step'] ==
                                                  "transport" ||
                                              dataTimeline['data']['step'] ==
                                                  "store_thai" ||
                                              dataTimeline['data']['step'] ==
                                                  "overdue" ||
                                              dataTimeline['data']['step'] ==
                                                  "delivery"
                                          ? primaryColor
                                          : Colors.black54
                                      : Colors.black54,
                                  size: 45,
                                ),
                                dataTimeline.length > 0
                                    ? dataTimeline['data']['step'] == "track"
                                        ? Positioned(
                                            // draw a red marble
                                            top: 10.0,
                                            right: 10.0,
                                            child: Icon(Icons.touch_app,
                                                size: 25.0,
                                                color: Colors.yellowAccent),
                                          )
                                        : SizedBox(
                                            height: 0,
                                          )
                                    : SizedBox(
                                        height: 0,
                                      ),
                              ]),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "จัดส่งสินค้า",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TimelineTile(
                      topLineStyle: LineStyle(color: Colors.red),
                      bottomLineStyle: LineStyle(
                          color: dataTimeline.length > 0
                              ? dataTimeline['data']['step'] == "store_thai" ||
                                      dataTimeline['data']['step'] ==
                                          "overdue" ||
                                      dataTimeline['data']['step'] == "delivery"
                                  ? Colors.red
                                  : Colors.black54
                              : Colors.black54),
                      alignment: TimelineAlign.center,
                      isFirst: true,
                      indicatorStyle: IndicatorStyle(
                        width: 20,
                        color: dataTimeline.length > 0
                            ? dataTimeline['data']['step'] == "store_thai" ||
                                    dataTimeline['data']['step'] == "overdue" ||
                                    dataTimeline['data']['step'] == "delivery"
                                ? Colors.red
                                : Colors.black54
                            : Colors.black54,
                        indicatorY: 0.2,
                        padding: EdgeInsets.all(8),
                      ),
                      leftChild: Container(
                        child: GestureDetector(
                          onTap: () {
                            if (dataTimeline.length > 0 &&
                                dataTimeline['data']['step'] == "transport" &&
                                dataTimeline['data']['list'][3]['show'] ==
                                    true) {
                              String title = "";
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => dialogTimeline(
                                    title,
                                    picDenied,
                                    context,
                                    familyMemberLabel,
                                    familyMemberName,
                                    dataTimeline['data']['id'],
                                    dataTimeline.length > 0
                                        ? dataTimeline['data']['step']
                                        : 'transport',
                                    familyMemberField),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              Stack(children: <Widget>[
                                GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    Icons.directions_boat,
                                    color: dataTimeline.length > 0
                                        ? dataTimeline['data']['step'] ==
                                                    "store_thai" ||
                                                dataTimeline['data']['step'] ==
                                                    "overdue" ||
                                                dataTimeline['data']['step'] ==
                                                    "delivery"
                                            ? primaryColor
                                            : Colors.black54
                                        : Colors.black54,
                                    size: 45,
                                  ),
                                ),
                                dataTimeline.length > 0
                                    ? dataTimeline['data']['step'] ==
                                            "transport"
                                        ? Positioned(
                                            // draw a red marble
                                            top: 10.0,
                                            right: 10.0,
                                            child: Icon(Icons.touch_app,
                                                size: 25.0,
                                                color: Colors.yellowAccent),
                                          )
                                        : SizedBox(
                                            height: 0,
                                          )
                                    : SizedBox(
                                        height: 0,
                                      ),
                              ]),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "เข้าคลังไทย",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TimelineTile(
                      topLineStyle: LineStyle(color: Colors.red),
                      bottomLineStyle: LineStyle(
                          color: dataTimeline.length > 0
                              ? dataTimeline['data']['step'] == "overdue" ||
                                      dataTimeline['data']['step'] == "delivery"
                                  ? Colors.red
                                  : Colors.black54
                              : Colors.black54),
                      alignment: TimelineAlign.center,
                      isFirst: true,
                      indicatorStyle: IndicatorStyle(
                        width: 20,
                        color: dataTimeline.length > 0
                            ? dataTimeline['data']['step'] == "overdue" ||
                                    dataTimeline['data']['step'] == "delivery"
                                ? Colors.red
                                : Colors.black54
                            : Colors.black54,
                        indicatorY: 0.2,
                        padding: EdgeInsets.all(8),
                      ),
                      rightChild: Container(
                        child: GestureDetector(
                          onTap: () {
                            if (dataTimeline.length > 0 &&
                                dataTimeline['data']['step'] == "store_thai" &&
                                dataTimeline['data']['list'][4]['show'] ==
                                    true) {
                              String title = "";
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => dialogTimeline(
                                    title,
                                    picDenied,
                                    context,
                                    familyMemberLabel,
                                    familyMemberName,
                                    dataTimeline['data']['id'],
                                    dataTimeline.length > 0
                                        ? dataTimeline['data']['step']
                                        : 'store_thai',
                                    familyMemberField),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              Stack(children: <Widget>[
                                Icon(
                                  Icons.directions_boat,
                                  color: dataTimeline.length > 0
                                      ? dataTimeline['data']['step'] ==
                                                  "overdue" ||
                                              dataTimeline['data']['step'] ==
                                                  "delivery"
                                          ? primaryColor
                                          : Colors.black54
                                      : Colors.black54,
                                  size: 45,
                                ),
                                dataTimeline.length > 0
                                    ? dataTimeline['data']['step'] ==
                                            "store_thai"
                                        ? Positioned(
                                            // draw a red marble
                                            top: 10.0,
                                            right: 10.0,
                                            child: Icon(Icons.touch_app,
                                                size: 25.0,
                                                color: Colors.yellowAccent),
                                          )
                                        : SizedBox(
                                            height: 0,
                                          )
                                    : SizedBox(
                                        height: 0,
                                      ),
                              ]),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "รอชำระค่าส่ง",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TimelineTile(
                      topLineStyle: LineStyle(color: Colors.red),
                      bottomLineStyle: LineStyle(
                          color: dataTimeline.length > 0
                              ? dataTimeline['data']['step'] == "delivery"
                                  ? Colors.red
                                  : Colors.black54
                              : Colors.black54),
                      alignment: TimelineAlign.center,
                      isFirst: true,
                      indicatorStyle: IndicatorStyle(
                        width: 20,
                        color: dataTimeline.length > 0
                            ? dataTimeline['data']['step'] == "overdue" ||
                                    dataTimeline['data']['step'] == "delivery"
                                ? Colors.red
                                : Colors.black54
                            : Colors.black54,
                        indicatorY: 0.2,
                        padding: EdgeInsets.all(8),
                      ),
                      leftChild: Container(
                        child: GestureDetector(
                          onTap: () {
                            if (dataTimeline.length > 0 &&
                                dataTimeline['data']['step'] == "overdue" &&
                                dataTimeline['data']['list'][5]['show'] ==
                                    true) {
                              String title = "";
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => dialogTimeline(
                                    title,
                                    picDenied,
                                    context,
                                    familyMemberLabel,
                                    familyMemberName,
                                    dataTimeline['data']['id'],
                                    dataTimeline.length > 0
                                        ? dataTimeline['data']['step']
                                        : 'overdue',
                                    familyMemberField),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              Stack(children: <Widget>[
                                Icon(
                                  Icons.directions_boat,
                                  color: dataTimeline.length > 0
                                      ? dataTimeline['data']['step'] ==
                                              "delivery"
                                          ? primaryColor
                                          : Colors.black54
                                      : Colors.black54,
                                  size: 45,
                                ),
                                dataTimeline.length > 0
                                    ? dataTimeline['data']['step'] == "overdue"
                                        ? Positioned(
                                            // draw a red marble
                                            top: 10.0,
                                            right: 10.0,
                                            child: Icon(Icons.touch_app,
                                                size: 25.0,
                                                color: Colors.yellowAccent),
                                          )
                                        : SizedBox(
                                            height: 0,
                                          )
                                    : SizedBox(
                                        height: 0,
                                      ),
                              ]),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "จัดส่งเสร็จสิ้น",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TimelineTile(
                      topLineStyle: LineStyle(color: Colors.red),
                      bottomLineStyle: LineStyle(
                          color: dataTimeline.length > 0
                              ? dataTimeline['data']['step'] == "delivery"
                                  ? Colors.red
                                  : Colors.black54
                              : Colors.black54),
                      alignment: TimelineAlign.center,
                      isLast: true,
                      indicatorStyle: IndicatorStyle(
                        width: 20,
                        color: dataTimeline.length > 0
                            ? dataTimeline['data']['step'] == "delivery"
                                ? Colors.red
                                : Colors.black54
                            : Colors.black54,
                        indicatorY: 0.2,
                        padding: EdgeInsets.all(8),
                      ),
                      leftChild: Container(
                        child: Column(
                          children: [
                            Stack(children: <Widget>[
                              Icon(
                                Icons.check_circle,
                                color: dataTimeline.length > 0
                                    ? dataTimeline['data']['step'] == "delivery"
                                        ? primaryColor
                                        : Colors.black54
                                    : Colors.black54,
                                size: 45,
                              ),
                            ]),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "จัดส่งเสร็จสิ้น",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
