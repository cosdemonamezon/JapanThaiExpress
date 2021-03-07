import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:flutter/material.dart';

class DetailNews extends StatefulWidget {
  DetailNews({Key key}) : super(key: key);

  @override
  _DetailNewsState createState() => _DetailNewsState();
}

class _DetailNewsState extends State<DetailNews> {
  String news ="温めて浮かせるこすらないメイク落とし【クーポンで10％OFF】クレンジング ホットジェル セラミド ホット ジェル 温感 温め W洗顔不要 毛穴 メイク落とし 化粧落とし ゲル おうち美容 おすすめ ランキング 天然 黒ずみ 角栓 日本製 [プリュ ボタニカル ホット クレンジングジェル（150g）][YP][通]1,390円 1～10営業日以内に発送予定（休業日除く）(344件)";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail News"),
      ),
      body: ListView(
        children: [
          SizedBox(height: 20,),
          Card(
            child: ListTile(
              title: Image.asset("assets/o5.jpg", fit: BoxFit.cover,),
              subtitle: Column(
                children: [
                  Text("＋3度の温感スチーム効果！"),
                  Text(news),
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