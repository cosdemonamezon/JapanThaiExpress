import 'package:JapanThaiExpress/UserScreens/News/DetailNews.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NewsScreen extends StatefulWidget {
  NewsScreen({Key key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool isLoading = true;
  List<dynamic> news = [];
  String tokendata = "";
  SharedPreferences prefs;
  // String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJsdW1lbi1qd3QiLCJzdWIiOjYsImlhdCI6MTYxNTcxNTA3NCwiZXhwIjoxNjE1ODAxNDc0fQ.qX0GNbwo7PNY8TD4AXYQwGywdrOVmolOYum9wg1sG84";

  @override
  void initState() {
    super.initState();
    _listnews();
  }

  _listnews() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    
    setState(() {
      //isLoading = true;
      tokendata = token['data']['token'];
    });

    var url = pathAPI + 'api/list_news';
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token['data']['token']
      }
    );
    if (response.statusCode == 200) {
      //print("object");
      final Map<String, dynamic> newsdata = convert.jsonDecode(response.body);
      print(newsdata);
      if (newsdata['code'] == 200) {
        print(newsdata['message']);
        setState(() {
          isLoading = false;
          news = newsdata['data'];
        });
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
        title: Text("News"),
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
        padding: EdgeInsets.symmetric(horizontal: 5),
        color: Colors.grey[200],
        child: isLoading == true ?
        Center(
          child: CircularProgressIndicator(),
        ) 
        :Column(
          children: [
            SizedBox(height: 20,),
            Container(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: news.length,
                itemBuilder: (BuildContext context, int index){
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    child: newsCard(
                      news[index]['photo']==null?'https://picsum.photos/200/300' :news[index]['photo'],
                      news[index]['title'],
                      news[index]['detail']
                    ),
                  );
                },
                
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(),
    );
  }

  Container newsCard(String img, String title, String subtitle) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: kFontPrimaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: GestureDetector(
        onTap: (){
          var arg = {
            "title": title, 
            "subtitle": subtitle, 
            "img": img
          };
          MyNavigator.goToNewsDetial(context, arg);
          // Navigator.push(
          //   context, MaterialPageRoute(builder: (context) => DetailNews()));
          // Navigator.pushNamed(context, "/newdetail", arguments: {
          //   'title': title,
          //   'detail': subtitle,
          //   'photo': img,
          // });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Container(
                height: 120,
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
                    fit: BoxFit.fill,
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kTextButtonColor),
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