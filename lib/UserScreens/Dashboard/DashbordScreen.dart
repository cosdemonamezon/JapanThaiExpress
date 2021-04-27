import 'package:JapanThaiExpress/UserScreens/MyOders/OdersScreen.dart';
import 'package:JapanThaiExpress/UserScreens/News/NewsScreen.dart';
import 'package:JapanThaiExpress/UserScreens/Products/ProductScreen.dart';
import 'package:JapanThaiExpress/UserScreens/Profile/ProfileScreen.dart';
import 'package:JapanThaiExpress/UserScreens/Promotion/PromotionScreen.dart';
import 'package:JapanThaiExpress/UserScreens/Service/Service.dart';
import 'package:JapanThaiExpress/UserScreens/Wallet/WalletScreen.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class DashbordScreen extends StatefulWidget {
  DashbordScreen({Key key}) : super(key: key);

  @override
  _DashbordScreenState createState() => _DashbordScreenState();
}

class _DashbordScreenState extends State<DashbordScreen> {
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
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(        
        title: Text("Dashbord"),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.account_circle, size: 40, color: Colors.white,), 
        //     onPressed: (){
        //       // Navigator.push(
        //       //   context, MaterialPageRoute(builder: (context) => ProfileScreen())
        //       // );
        //       MyNavigator.goToProfileScreen(context);
        //     }
        //   ),
        // ],
      ),
      body: Container(
        height: height,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 10,),
            // Container(
            //   width: double.infinity,
            //   child: CarouselSlider.builder(
            //     itemCount: pathimg.length,
            //     options: CarouselOptions(
            //       autoPlay: true,
            //       aspectRatio: 2.0,
            //       viewportFraction: 0.75,
            //       enlargeCenterPage: true,
            //       initialPage: 9,
            //     ),
            //     itemBuilder: (context, index, realIdx){
            //       if (pathimg.length != 0) {
            //         return Container(
            //           child: Center(
            //             child: Image.asset(pathimg[index], fit: BoxFit.cover,),
            //           ),
            //         );
            //       }
            //     }
            //   ),
            // ),
            // SizedBox(height: 30,),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(3.0),
                children: [
                  dashboardItem("รายการซื้อสินค้า", Icons.add_shopping_cart, 1, context),
                  dashboardItem("บริการของเรา", Icons.settings_applications, 2, context),
                  dashboardItem("ผลิตภัณฑ์", Icons.card_giftcard, 3, context),
                  dashboardItem("กระเป๋าสตางค์", Icons.credit_card, 4, context),
                  dashboardItem("ข่าว", Icons.fiber_new, 5, context),
                  dashboardItem("โปรโมชั่น", Icons.new_releases, 6, context),
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
      borderRadius: BorderRadius.circular(20.0),
    ),
    elevation: 5.0,
    margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
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
            MyNavigator.goToMyOrder(context);
          } else if (page == 2) {
            MyNavigator.goToService(context);
          } else if (page == 3) {
            MyNavigator.goToProductScreen(context);
          } else if (page == 4) {
            MyNavigator.goToWallet(context);
          } else if (page == 5) {
            MyNavigator.goToNews(context);
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => NewsScreen()));
          } else if (page == 6) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => PromotionScreen()));
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
                  style: new TextStyle(fontSize: 20.0, color: Color(0xFFd73925)),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}