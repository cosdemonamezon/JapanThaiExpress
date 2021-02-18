import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:flutter/material.dart';

class PrechaseScreen extends StatefulWidget {
  PrechaseScreen({Key key}) : super(key: key);

  @override
  _PrechaseScreenState createState() => _PrechaseScreenState();
}

class _PrechaseScreenState extends State<PrechaseScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text("Purchase Orders"),
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
              ]),
        ),
        body: TabBarView(
          children: [
            Container(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  //messageCard("Learn Git and GitHub without any code!", Icons.account_box, "Software developer"),
                  buildCard(
                    "100/17.フマキラー スキンベープ 虫よけスプレー ミストタイプ キティ ピーチの香り(200ml) 185.00 บาท",
                    "assets/o1.jpg",
                  ),
                  buildCard(
                    "50/13.口内炎パッチ大正A 10枚 220.00 บาท",
                    "assets/o2.jpg",
                  ),
                  buildCard(
                    "50/16.資生堂フィーノ プレミアムタッチ 浸透美容液ヘアマスク 230g 270.00 บาท",
                    "assets/o3.jpg",
                  ),
                  buildCard(
                    "50/68.Blueクリニカ アドバンテージ ハミガキ クールミン 115.00 บาท",
                    "assets/o4.jpg",
                  ),
                  buildCard(
                    "50/12.ニューアンメルツヨコヨコA 80mL 180.00 บาท",
                    "assets/o5.jpg",
                  ),
                  buildCard(
                    "50/29.ウーノ ホイップウォッシュ モイスト 125.00 บาท",
                    "assets/o6.jpg",
                  ),
                  buildCard(
                    "50/6.DHC コラーゲン 60日分 360粒 345.00 บาท",
                    "assets/o7.jpg",
                  ),
                  buildCard(
                    "50/25.ペアA錠 120錠 225.00 บาท",
                    "assets/o8.jpg",
                  ),
                ],
              ),
            ),
            Icon(Icons.movie),
          ],
        ),
        bottomNavigationBar: Navigation(),
      ),
    );
  }

  Card buildCard(String title, String image) {
    return Card(
      child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(image),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MaterialButton(
                onPressed: () {},
                color: Color(0xffdd4b39),
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
