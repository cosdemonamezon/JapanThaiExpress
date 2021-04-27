import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class OdersScreen extends StatefulWidget {
  OdersScreen({Key key}) : super(key: key);

  @override
  _OdersScreenState createState() => _OdersScreenState();
}

class _OdersScreenState extends State<OdersScreen> {
  bool isLoading = false;
  SharedPreferences prefs;
  List<dynamic> order = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int totalResults = 0;
  int page = 1;
  int pageSize = 10;

  @override
  void initState() {
    super.initState();
    _getOrderlist();
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    //ทุกครั้งที่รีเฟรชจะเคียร์อาร์เรย์และ set page เป็น 1
    setState(() {
      order.clear();
      page = 1;
    });
    _getOrderlist(); //ทุกครั้งที่ทำการรีเฟรช จะดึงข้อมูลใหม่
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
        _getOrderlist();
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

  _getOrderlist() async{
    try {
      setState(() {
        page == 1 ? isLoading = true : isLoading = false;
      });
      prefs = await SharedPreferences.getInstance();
      var tokenString = prefs.getString('token');
      var token = convert.jsonDecode(tokenString);
      var url = Uri.parse(pathAPI +
          'api/app/order_list?status=&page=$page&page_size=$pageSize');
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
        final Map<String, dynamic> orderdata = convert.jsonDecode(response.body);
        setState(() {
          totalResults = orderdata['data']['total'];
          order.addAll(orderdata['data']['data']);
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
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text("Pre Oders"),
          leading: IconButton(
            onPressed: () {
              MyNavigator.goBackUserHome(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
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
                  child: Text("New Orders"),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("History"),
                ),
              ),
              
            ]
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: ListView.builder(
                itemCount: order.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                itemBuilder: (BuildContext context, int index){
                  return buildCard(
                    order[index]['code'],
                    order[index]['product_name'],
                    order[index]['qty'],
                    order[index]['price'],
                    order[index]['total'],
                  );
                }
                
              ),
            ),

            Icon(Icons.movie),
          ],
        ),
        bottomNavigationBar: NavigationBar(),
      ),
    );
  }

  Card buildCard(String title, String subtitle, String subtitle1, String subtitle2, String subtitle3,) {
    return Card(
      child: ListTile(        
        title: Column(
          children: [
            Row(
              children: [
                Text(
                  "รหัสสินค้า  ：",
                  style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black, fontSize: 17,
                  ),
                ),
              ],
            ),
          ],
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("ชื่อสินค้า     ："),
                Text(subtitle),
              ],
            ),
            Row(
              children: [
                Text("จำนวน        ："),
                Text(subtitle1+ "    ชิ้น"),
              ],
            ),
            Row(
              children: [
                Text("ราคาสินค้า ："),
                Text(subtitle2 + " บาท"),
              ],
            ),
            Row(
              children: [
                Text("ยอดรวม     ："),
                Text(subtitle3+ " บาท"),
              ],
            ),
          ],
        )
      ),
    );
  }
}

Card messageCard(String title, IconData icon, String subtitle) {
  return Card(
    child: ListTile(
      leading: Icon(icon, color: Colors.blue,size: 40.0,),
      title: Text(
        title ,style: TextStyle(fontWeight: FontWeight.w400),
      ),
      subtitle: Text(subtitle),
    ),
  );
}

