import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        //centerTitle: true,
        title: Text("NOTIFICATION"),
      ),
      body: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: ListView(
          children: [
            messageCard(
              "410ポイント1倍9倍UP内訳を見る",
              "assets/icons/Megaphone.svg",
              "もこもこ泡石鹸とクレンジングで、汚れを残さず潤いを与える［素肌美人］スペシャルセット★【ポイント10倍】【送料無"
            ),
            SizedBox(height: 5,),
            messageCard(
              "16ポイント1倍内訳を見る",
              "assets/icons/Megaphone.svg",
              "ハリと潤いを追求する、ヒト幹細胞入り濃白美容液美容液 ヒト幹細胞 セラミド プラセンタ 荒れ 乾燥 保湿 ハリ 潤い ルイール 日"
            ),
            SizedBox(height: 5,),
            messageCard(
              "4,170円  送料無料",
              "assets/icons/Megaphone.svg",
              "【ポイント10倍】【送料無料】クレンジングはジェルorオイルから選べる！［プリュ 時短スキンケアセット[クレンジン"
            ),
            SizedBox(height: 5,),
            messageCard(
              "2,780円 [通]【送料無料】",
              "assets/icons/Megaphone.svg",
              "プリュローション＋ミルクのしっとり潤いセット【ポイント5倍】化粧水 乳液 セット 詰め替え パウチ ボトル 組み合わせ ［プリュ うる"
            ),
            SizedBox(height: 5,),
            messageCard(
              "1,250円 不使用［プリ",
              "assets/icons/Megaphone.svg",
              "たったひと塗りの時短スキンケア！浸透型カプセル配合オールインワンゲル！【10％OFF】"
            ),
            SizedBox(height: 5,),
            messageCard(
              "2,220円 [通][YP]",
              "assets/icons/Megaphone.svg",
              "目元の印象で差を付ける！結果重視の特濃アイクリーム【20％OFF】クリーム アイクリーム プラセンタ たるみ くま 目の下のたるみ ハリ 目元クリーム 口元 年齢 ピンポイ"
            ),
            SizedBox(height: 5,),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(),
    );
  }

  Card messageCard(String title, String img, String subtitle){
    return Card(
      color: kBackgroundColor,
      child: GestureDetector(
        onTap: (){},
        child: ListTile(
          leading: Container(
            child: SvgPicture.asset(
              img,
              height: 30,
              width: 30,
              fit: BoxFit.fill,
              color: kCicleColor,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: kFontPrimaryColor),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 13,
              color: kFontPrimaryColor),
          ),
        ),
      ),
    );
  }
}