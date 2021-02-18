import 'package:JapanThaiExpress/UserScreens/News/DetailNews.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
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
          Card(
            child: ListTile(
              title: Image.asset("assets/o5.jpg", fit: BoxFit.cover,),
              subtitle: Column(
                children: [
                  Text("A Material Design raised button. A raised button consists of a rectangular piece of material that hovers over the interface. Documentation. Input and selections"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MaterialButton(
                        onPressed: (){
                          Navigator.push(
                            context, MaterialPageRoute(builder: (context) => DetailNews())
                          );
                        },
                        color: Colors.green,
                        child: Text(
                          "Details",
                          style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 5,),
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/1.png",),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage("assets/pic-1.png",),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "A Dart package for reading XDG ",
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          Text("This Dart package can be used to determine the directory"),
                          Text("id Ago"),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                    Icon(Icons.more_vert)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(),
    );
  }
}