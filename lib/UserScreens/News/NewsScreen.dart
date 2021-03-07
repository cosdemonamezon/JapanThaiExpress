import 'package:JapanThaiExpress/UserScreens/News/DetailNews.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  NewsScreen({Key key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
      ),
      body: ListView(
        children: [
          SizedBox(height: 20,),
          // Card(
          //   child: ListTile(
          //     title: Image.asset("assets/o5.jpg", fit: BoxFit.cover,),
          //     subtitle: Column(
          //       children: [
          //         Text("A Material Design raised button. A raised button consists of a rectangular piece of material that hovers over the interface. Documentation. Input and selections"),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.end,
          //           children: [
          //             MaterialButton(
          //               onPressed: (){
          //                 Navigator.push(
          //                   context, MaterialPageRoute(builder: (context) => DetailNews())
          //                 );
          //               },
          //               color: Colors.green,
          //               child: Text(
          //                 "Details",
          //                 style: TextStyle(
          //                   fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12,
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(height: 5,),
          newsCard(
            "assets/mask2103.jpg",
            "送料無料",
            "品 プラセンタ 白金 日本製 マスク 35枚入【2020楽天ベストコスメ】化粧, 品 プラセンタ 白金 日本製 マスク 35枚入【クーポンで半額695円】【送料無料】パック シートマスク"
          ),
          SizedBox(height: 5,),
          newsCard(
            "assets/amicle2103.jpg",
            "楽天ベストコスメ入賞",
            "肌への優しさにこだわった、アミノ酸 美容液クレンジングジェル！蒟蒻ボールが毛穴の奥まですっきりキレイにメイク落とし【ポイント10倍】クレンジング ジェル"
          ),
          SizedBox(height: 5,),
          newsCard(
            "assets/bhcle2103.jpg",
            "＋3度の温感スチーム効果！",
            "温めて浮かせるこすらないメイク落とし【クーポンで10％OFF】クレンジング ホットジェル セラミド ホット ジェル 温感 温め W洗顔不要 毛穴 メイク落とし 化粧落"
          ),
          SizedBox(height: 5,),
          newsCard(
            "assets/amiclep10.jpg",
            "商品番号 	PCAG21-000150A",
            "持ち運びにも便利♪お客様の声から生まれた美容液クレンジングジェルのチューブタイプ(100g）！クレンジング メイク落とし メイクオフ お試し"
          ),
          SizedBox(height: 5,),
          newsCard(
            "assets/plgp5.jpg",
            "東京都への最安送料",
            "贅沢使いで古い角質・黒ずみオールオフ！顔も体も全身まるごと素肌磨き♪お肌に優しいまろやかピーリングジェル 黒ずみ 毛穴 顔 全身 ボディ 痛くない 除去 角"
          ),
          SizedBox(height: 5,),
          newsCard(
            "assets/mlkp5.jpg",
            "偽サイト・偽アカウントにご注意",
            "ミルクで養う「やわらか美肌」！美容成分たっぷりの万能型うるおいミルク☆ 【ポイント5倍】乳液 大容量 保湿 敏感肌 先行導入 EGF プラセンタ ボディミルク"
          ),
          SizedBox(height: 5,),
        ],
      ),
      bottomNavigationBar: NavigationBar(),
    );
  }

  Container newsCard(String img, String title, String subtitle) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: kInputSearchColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: GestureDetector(
        onTap: (){
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => DetailNews()));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  //color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(img),
                  ),
                ),
              ),
              SizedBox(width: 16,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10,),
                      child: Text(
                        title,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kFontPrimaryColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        subtitle,
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: kFontSecondTextColor),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}