import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Service extends StatefulWidget {
  Service({Key key}) : super(key: key);

  @override
  _ServiceState createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
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
        //centerTitle: true,
        title: Text("Service"),
      ),
      body: Container(
height: height,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: CarouselSlider.builder(
                itemCount: pathimg.length,
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2.0,
                  viewportFraction: 0.75,
                  enlargeCenterPage: true,
                  initialPage: 9,
                ),
                itemBuilder: (context, index, realIdx){
                  if (pathimg.length != 0) {
                    return Container(
                      child: Center(
                        child: Image.asset(pathimg[index], fit: BoxFit.cover,),
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
                  dashboardItem("รับฝากส่ง", Icons.supervised_user_circle, 1, context),
                  dashboardItem("รับฝากซื้อ", Icons.supervised_user_circle, 2, context),
                  dashboardItem("ประมูลสินค้า", Icons.supervised_user_circle, 3, context),
                  dashboardItem("รับโอนเงิน", Icons.supervised_user_circle, 4, context),
                  
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
        color: Color(0xFF343434),
        borderRadius: BorderRadius.circular(15),
      ),
      child: new InkWell(
        onTap: () {
          if (page == 1) {
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => PrechaseScreen()));
          } else if (page == 2) {
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => PreoderScreen()));
          } else if (page == 3) {
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => MaintainScreen()));
          } else if (page == 4) {
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => DepositScreen()));
          } else if (page == 5) {
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => CustomerScreen()));
          } else if (page == 6) {
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => MessageScreen()));
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
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.0),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  title,
                  style: new TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}