import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class PromotionScreen extends StatefulWidget {
  PromotionScreen({Key key}) : super(key: key);

  @override
  _PromotionScreenState createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  bool isLoading = false;
  bool btnClick = true;
  SharedPreferences prefs;
  List<dynamic> promotion = []; //ประกาศตัวแปร อาร์เรย์ ไว้
  int totalResults = 0;
  int page = 1;
  int pageSize = 10;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _promotionList();
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    //ทุกครั้งที่รีเฟรชจะเคียร์อาร์เรย์และ set page เป็น 1
    setState(() {
      promotion.clear();
      page = 1;
    });
    _promotionList(); //ทุกครั้งที่ทำการรีเฟรช จะดึงข้อมูลใหม่
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
        _promotionList();
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

  _promotionList() async {
    try {
      setState(() {
        page == 1 ? isLoading = true : isLoading = false;
      });
      prefs = await SharedPreferences.getInstance();
      var tokenString = prefs.getString('token');
      var token = convert.jsonDecode(tokenString);
      var url = Uri.parse(
          pathAPI + 'api/app/promotion_list?page=$page&page_size=$pageSize');
      var response = await http.get(
        url,
        headers: {
          //'Content-Type': 'application/json',
          'Authorization': token['data']['token']
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> promotiondata =
            convert.jsonDecode(response.body);
        setState(() {
          totalResults = promotiondata['data']['total'];
          promotion.addAll(promotiondata['data']['data']);
          isLoading = false;
        });
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("โปรโมชั่น"),
        leading: IconButton(
            onPressed: () {
              MyNavigator.goBackUserHome(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            )),
      ),
      body: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        color: Colors.grey[200],
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
                      //body = Text("ไม่พบข้อมูล");
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
                    itemCount: promotion.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildCard(
                        //promotion[index]['name'],
                        promotion[index]['code'],
                        promotion[index]['discount'],
                        promotion[index]['type'],
                        //promotion[index]['description']==null?'ไม่มีข้อมูล' :promotion[index]['description'],
                      );
                    }),
              ),
      ),
      bottomNavigationBar: NavigationBar(),
    );
  }

  Card buildCard(
    String title,
    String title2,
    String type,
  ) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Card(
      child: ListTile(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                type == "fix"
                    ? Text(
                        "ส่วนลด " + title2 + " บาท",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      )
                    : Text(
                        "ส่วนลด " + title2 + " เปอร์เซ็น",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
              ],
            ),
            MaterialButton(
              onPressed: () {
                Clipboard.setData(new ClipboardData(text: title));
                final snackBar = SnackBar(
                  content: Container(
                    height: height * 0.05,
                    child: Text(
                      'คัดลอกข้อความสำเร็จ !',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  action: SnackBarAction(
                    label: 'ตกลง',
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  ),
                );

                // Find the ScaffoldMessenger in the widget tree
                // and use it to show a SnackBar.
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              color: primaryColor,
              child: Text(
                "คัดลอก",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        // subtitle: Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     MaterialButton(
        //       onPressed: () {
        //         //MyNavigator.goToTimelineOrders(context);
        //       },
        //       color: primaryColor,
        //       child: Text(
        //         "ดูเพิ่ม",
        //         style: TextStyle(
        //           fontWeight: FontWeight.bold,
        //           color: Colors.white,
        //           fontSize: 12,
        //         ),
        //       ),
        //     ),
        //   ],
        // )
      ),
    );
  }
}

// Card buildCard(String title, String image) {
//     return Card(
//       child: ListTile(
//         leading: CircleAvatar(
//           radius: 25,
//           backgroundImage: AssetImage(image),
//         ),
//         title: Text(
//           title,
//           style: TextStyle(
//             fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14,
//           ),
//         ),
//         subtitle: Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             MaterialButton(
//               onPressed: (){},
//               color: Colors.green,
//               child: Text(
//                 "Details",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12,
//                 ),
//               ),
//             ),
//           ],
//         )
//       ),
//     );
//   }

Card messageCard(String title, IconData icon, String subtitle) {
  return Card(
    child: ListTile(
      leading: Icon(
        icon,
        color: Colors.blue,
        size: 40.0,
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
      subtitle: Text(subtitle),
    ),
  );
}
