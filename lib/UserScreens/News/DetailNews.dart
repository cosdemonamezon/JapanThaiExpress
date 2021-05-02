import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:flutter/material.dart';

class DetailNews extends StatefulWidget {
  DetailNews({Key key}) : super(key: key);

  @override
  _DetailNewsState createState() => _DetailNewsState();
}

class _DetailNewsState extends State<DetailNews> {
  String news =
      "温めて浮かせるこすらないメイク落とし【クーポンで10％OFF】クレンジング ホットジェル セラミド ホット ジェル 温感 温め W洗顔不要 毛穴 メイク落とし 化粧落とし ゲル おうち美容 おすすめ ランキング 天然 黒ずみ 角栓 日本製 [プリュ ボタニカル ホット クレンジングジェル（150g）][YP][通]1,390円 1～10営業日以内に発送予定（休業日除く）(344件)";
  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    print(data);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            )),
        title: Text("Detail News"),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Card(
            child: ListTile(
              title: data['img'] != null
                  ? Image.network(
                      data['img'],
                      fit: BoxFit.cover,
                    )
                  : Image.network("https://picsum.photos/200/300",
                      fit: BoxFit.cover),
              subtitle: Column(
                children: [
                  data['title'] != null
                      ? Text(
                          data['title'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )
                      : Text("ไม่พบข้อมูล"),
                  SizedBox(
                    height: 10,
                  ),
                  data['subtitle'] != null
                      ? Text(
                          data['subtitle'],
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14),
                        )
                      : Text("ไม่พบข้อมูล"),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(),
    );
  }
}
