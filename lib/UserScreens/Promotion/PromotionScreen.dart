import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PromotionScreen extends StatefulWidget {
  PromotionScreen({Key key}) : super(key: key);

  @override
  _PromotionScreenState createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  bool isLoading = false;
  SharedPreferences prefs;
  List<dynamic> promotion = []; //ประกาศตัวแปร อาร์เรย์ ไว้
  int totalResults = 0;
  int page = 1;
  int pageSize = 10;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _romotionList();
  }

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    //ทุกครั้งที่รีเฟรชจะเคียร์อาร์เรย์และ set page เป็น 1
    setState(() { 
      promotion.clear();
      page = 1;
    });
    _romotionList();//ทุกครั้งที่ทำการรีเฟรช จะดึงข้อมูลใหม่
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    //items.add((items.length+1).toString());
    if (page < (totalResults / pageSize).ceil()) {
      if(mounted){
        print("mounted");
        setState(() {
          page = ++page;
        });
        _romotionList();
        _refreshController.loadComplete();
      }
      else{
        print("unmounted");
        _refreshController.loadComplete();
      }
    } else {
      _refreshController.loadNoData();
      _refreshController.resetNoData();
    }
  }

  _romotionList() async{
    try {
      setState(() {
        page == 1 ? isLoading = true : isLoading = false;
      });
      prefs = await SharedPreferences.getInstance();
      var tokenString = prefs.getString('token');
      var token = convert.jsonDecode(tokenString);
      var url = Uri.parse(pathAPI + 'api/app/promotion_list?page=$page&page_size=$pageSize');
      var response = await http.get(
        url,
        headers: {
          //'Content-Type': 'application/json',
          'Authorization': token['data']['token']
        },   
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> promotiondata = convert.jsonDecode(response.body);
        setState(() {
          totalResults = promotiondata['data']['total'];
          promotion.addAll(promotiondata['data']['data']);
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Promotion"),
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
        padding: EdgeInsets.symmetric(horizontal: 10),
        color: Colors.grey[200],
        child: isLoading == true ?
        Center(
          child: CircularProgressIndicator(),
        ) 
        :SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: ClassicHeader(
            refreshStyle: RefreshStyle.Follow,
            refreshingText: 'กำลังโหลด.....',
            completeText: 'โหลดข้อมูลสำเร็จ',
          ),
          footer: CustomFooter(
            builder: (BuildContext context,LoadStatus mode){
              Widget body ;
              if(mode==LoadStatus.idle){
                //body =  Text("ไม่พบรายการ");
              }
              else if(mode==LoadStatus.loading){
                body =  CircularProgressIndicator();
              }
              else if(mode == LoadStatus.failed){
                body = Text("Load Failed!Click retry!");
              }
              else if(mode == LoadStatus.canLoading){
                body = Text("release to load more");
              }
              else if (mode == LoadStatus.noMore){
                //body = Text("No more Data");
                body = Text("ไม่พบข้อมูล");
              }
              return Container(
                height: 55.0,
                child: Center(child:body),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView.builder(
            itemCount: promotion.length,
            itemBuilder: (BuildContext context, int index){
              return buildCard(
                promotion[index]['name'],
                promotion[index]['code'],
                promotion[index]['discount'],
                promotion[index]['description']==null?'ไม่มีข้อมูล' :promotion[index]['description'],
              );
            }
            
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(),
    );
    
  }
}

Card buildCard(String title, String title2, String title3, String title4,){
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
        )
      ),
    );
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
      leading: Icon(icon, color: Colors.blue,size: 40.0,),
      title: Text(
        title ,style: TextStyle(fontWeight: FontWeight.w400),
      ),
      subtitle: Text(subtitle),
    ),
  );
}
