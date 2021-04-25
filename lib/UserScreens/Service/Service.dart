import 'package:JapanThaiExpress/UserScreens/Dashboard/DashbordScreen.dart';
import 'package:JapanThaiExpress/UserScreens/Service/Auction.dart';
import 'package:JapanThaiExpress/UserScreens/Service/Buystuff.dart';
import 'package:JapanThaiExpress/UserScreens/Service/Deposit.dart';
import 'package:JapanThaiExpress/UserScreens/Service/ReceiveMoney.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Service extends StatefulWidget {
  Service({Key key}) : super(key: key);

  @override
  _ServiceState createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  bool isLoading = false;
  List<dynamic> banner = [];
  String tokendata = "";
  SharedPreferences prefs;
  List<String> imgPath = [];
  List<String> pathimg = [
    "assets/o1.jpg",
    "assets/o2.jpg",
    "assets/o3.jpg",
    "assets/o4.jpg",
    "assets/o5.jpg",
    "assets/o6.jpg",
    "assets/o7.jpg",
  ];

  @override
  void initState() {
    super.initState();
    _getBanners();
  }

  _getBanners() async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    setState(() {
      isLoading = true;
      tokendata = token['data']['token'];
    });

    var url = Uri.parse(pathAPI + 'api/banners');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token['data']['token']
      }
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> imgdata = convert.jsonDecode(response.body);
      if (imgdata['code']==200) {
        setState(() {
          banner = imgdata['data'];
          // for (var i = 0; i < banner.length; i++) {
          //   imgPath = banner[i]['path'];
          // }
        });
        print(banner);
      } else {
      }
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        //centerTitle: true,
        title: Text("Service"),
        leading: IconButton(
          onPressed: (){
            MyNavigator.goBackUserHome(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,)
        ),
      ),
      body: Container(
        height: height,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: CarouselSlider.builder(
                itemCount: banner.length,
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2.0,
                  viewportFraction: 0.75,
                  enlargeCenterPage: true,
                  initialPage: 9,
                ),
                itemBuilder: (context, index, realIdx){
                  if (banner.length != 0) {
                    return Container(
                      child: Center(
                        child: Image.network(banner[index]['path'], fit: BoxFit.cover,),
                      ),
                    );
                  }
                }
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(3.0),
                children: [
                  dashboardItem("รับฝากส่ง", Icons.local_shipping, 1, context),
                  dashboardItem("รับฝากซื้อ", Icons.shopping_cart, 2, context),
                  dashboardItem("ประมูลสินค้า", Icons.monetization_on, 3, context),
                  dashboardItem("รับโอนเงิน", Icons.local_atm, 4, context),
                  
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(),
    );
  }
}

Card dashboardItem(String title, IconData icon, int page, context) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    elevation: 5.0,
    margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 15.0),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 3,
          color: Color(0xFFfafafa),
          //color: Color(0xFF343434),
          //color: Color(0xFFd73925),
          
        ),
        color: Color(0xFFfafafa),
        //color: Color(0xFFd73925),
        borderRadius: BorderRadius.circular(15),
      ),
      child: new InkWell(
        onTap: () {
          if (page == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Deposit()));
          } else if (page == 2) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Buystuff()));
          } else if (page == 3) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Auction()));
          } else if (page == 4) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ReceiveMoney()));
          } 
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          verticalDirection: VerticalDirection.down,
          children: [
            SizedBox(height: 20.0),
            Center(
              child: Icon(
                icon,
                size: 60.0,
                color: Color(0xFFd73925),
              ),
            ),
            SizedBox(height: 20.0),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  title,
                  style: new TextStyle(fontSize: 16.0, color: Color(0xFFd73925)),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}