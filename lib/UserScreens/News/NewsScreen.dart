import 'package:JapanThaiExpress/UserScreens/News/DetailNews.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class NewsScreen extends StatefulWidget {
  NewsScreen({Key key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool isLoading = false;
  List<dynamic> news = [];
  String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJsdW1lbi1qd3QiLCJzdWIiOjMsImlhdCI6MTYxNTEyNTQyOSwiZXhwIjoxNjE1MjExODI5fQ.vz4uB7ISPcWFwIa1Dncl8iy3yya2e4ftzGz3jOKGv3U";

  @override
  void initState() {
    super.initState();
    _listnews();
  }

  _listnews() async {
    
    setState(() {
      isLoading = true;
    });

    var url = pathAPI + 'api/list_news';
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token
      }
    );
    if (response.statusCode == 200) {
      print("object");
      final Map<String, dynamic> newsdata = convert.jsonDecode(response.body);
      print(newsdata);
      if (newsdata['code'] == 200) {
        print(newsdata['message']);
        setState(() {
          news = newsdata['data'];
        });
      } else {

      }
    } else {
      
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: news.length,
        itemBuilder: (BuildContext context, int index){
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: newsCard(
              news[index]['photo'],
              news[index]['title'],
              news[index]['detail']
            ),
          );
        },
        // children: [
                    
        //   SizedBox(height: 5,),
        //   newsCard(
        //     "assets/mask2103.jpg",
        //     "送料無料",
        //     "品 プラセンタ 白金 日本製 マスク 35枚入【2020楽天ベストコスメ】化粧, 品 プラセンタ 白金 日本製 マスク 35枚入【クーポンで半額695円】【送料無料】パック シートマスク"
        //   ),
        //   SizedBox(height: 5,),
        //   newsCard(
        //     "assets/amicle2103.jpg",
        //     "楽天ベストコスメ入賞",
        //     "肌への優しさにこだわった、アミノ酸 美容液クレンジングジェル！蒟蒻ボールが毛穴の奥まですっきりキレイにメイク落とし【ポイント10倍】クレンジング ジェル"
        //   ),
        //   SizedBox(height: 5,),
        //   newsCard(
        //     "assets/bhcle2103.jpg",
        //     "＋3度の温感スチーム効果！",
        //     "温めて浮かせるこすらないメイク落とし【クーポンで10％OFF】クレンジング ホットジェル セラミド ホット ジェル 温感 温め W洗顔不要 毛穴 メイク落とし 化粧落"
        //   ),
        //   SizedBox(height: 5,),
        //   newsCard(
        //     "assets/amiclep10.jpg",
        //     "商品番号 	PCAG21-000150A",
        //     "持ち運びにも便利♪お客様の声から生まれた美容液クレンジングジェルのチューブタイプ(100g）！クレンジング メイク落とし メイクオフ お試し"
        //   ),
        //   SizedBox(height: 5,),
        //   newsCard(
        //     "assets/plgp5.jpg",
        //     "東京都への最安送料",
        //     "贅沢使いで古い角質・黒ずみオールオフ！顔も体も全身まるごと素肌磨き♪お肌に優しいまろやかピーリングジェル 黒ずみ 毛穴 顔 全身 ボディ 痛くない 除去 角"
        //   ),
        //   SizedBox(height: 5,),
        //   newsCard(
        //     "assets/mlkp5.jpg",
        //     "偽サイト・偽アカウントにご注意",
        //     "ミルクで養う「やわらか美肌」！美容成分たっぷりの万能型うるおいミルク☆ 【ポイント5倍】乳液 大容量 保湿 敏感肌 先行導入 EGF プラセンタ ボディミルク"
        //   ),
        //   SizedBox(height: 5,),
        // ],
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
                    image: NetworkImage(img),
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kFontPrimaryColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: subtitle.length <= 120 ? Text(
                        subtitle,
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: kFontSecondTextColor),
                      )
                      :Text(
                        subtitle.substring(0, 120)+"...",
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