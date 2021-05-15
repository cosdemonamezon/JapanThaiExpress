import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:http/http.dart' as http;
import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class CustomerScreen extends StatefulWidget {
  CustomerScreen({Key key}) : super(key: key);

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  TextEditingController editingController = TextEditingController();
  int totalResults = 0;
  int page = 1;
  int pageSize = 10;
  bool isLoading = false;
  SharedPreferences prefs;
  List<dynamic> data = [];
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    _memberList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("รายการสมาชิก"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {});
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "ค้นหา",
                    hintText: "ค้นหา",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)))),
              ),
            ),
            Container(
              color: Colors.grey[300],
              child: isLoading == true
              ? Center(
                        child: CircularProgressIndicator(),
                      )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  padding: EdgeInsets.only(left: 5.0, right: 5.0),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                        onTap: () {},
                        child: Card(
                          color: Colors.white,
                          elevation: 4.0,
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 14.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                            width: 2.0, color: primaryColor))),
                                child: Image.network(
                                    'https://picsum.photos/200/300',
                                    width: 70),
                              ),
                              title: Text('Anon Thamcharoen'),
                              subtitle: Text('0859908017'),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                        Icons.keyboard_arrow_right_outlined),
                                    color: Colors.orange[900],
                                    iconSize: 30,
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navigation(),
    );
  }

  Future<void> _memberList() async {
    setState(() {
      page == 1 ? isLoading = true : isLoading = false;
    });
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = jsonDecode(tokenString);
    var url = Uri.parse(
        pathAPI + 'api/app/members?status=&page=$page&page_size=$pageSize');
    var response = await http.get(
      url,
      headers: {'Authorization': token['data']['token']},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> depdata = jsonDecode(response.body);
      setState(() {
        totalResults = depdata['data']['total'];
        data.addAll(depdata['data']['data']);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      var feedback = jsonDecode(response.body);
      Flushbar(
        title: '${feedback['message']}',
        message: 'รหัสข้อผิดพลาด : ${feedback['code']}',
        backgroundColor: Colors.redAccent,
        icon: Icon(
          Icons.error,
          size: 28.0,
          color: Colors.white,
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.blue[300],
      )..show(context);
    }
  }
}

Widget personDetailCard(person) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Card(
      // color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              'https://homepages.cae.wisc.edu/~ece533/images/cat.png')))),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  person['fname_th'],
                  style: TextStyle(color: Color(0xffdd4b39), fontSize: 18),
                ),
                Text(
                  person['tel'],
                  style: TextStyle(color: Color(0xffdd4b39), fontSize: 12),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}
