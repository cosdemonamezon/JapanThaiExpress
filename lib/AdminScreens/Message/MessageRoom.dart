import 'dart:io' as Io;
import 'dart:convert';
import 'package:JapanThaiExpress/AdminScreens/Message/MessageScreen.dart';
import 'package:JapanThaiExpress/UserScreens/Service/DetailStep.dart';
import 'package:JapanThaiExpress/UserScreens/Service/Service.dart';
import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:JapanThaiExpress/alert.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:JapanThaiExpress/constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/my_navigator.dart';

// import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:JapanThaiExpress/AdminScreens/Message/Message.dart';

class MessageRoom extends StatefulWidget {
  MessageRoom({Key key}) : super(key: key);

  @override
  _MessageRoomState createState() => _MessageRoomState();
}

class _MessageRoomState extends State<MessageRoom> {
  String picSuccess = "assets/success.png";
  String picDenied = "assets/denied.png";
  String picWanning = "assets/wanning.png";

  SharedPreferences prefs;
  SharedPreferences prefsNoti;

  Map<String, dynamic> dataTimeline = {};
  final List<Message> _messages = <Message>[];

  final _textController = TextEditingController();
  String id;

  List<String> messageType = [];
  List<String> messageText = [];
  List<String> messagePosition = [];
  List<String> messageTime = [];

  bool isLoading = false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routeArgs1 =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      id = routeArgs1['id'];
      _gettimeline(id);
    });
  }

  _gettimeline(String id) async {
    messageType = [];
    messageText = [];
    messagePosition = [];
    messageTime = [];

    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      isLoading = true;
    });
    // var url = pathAPI + 'api/preorder/' + id;
    var url = Uri.parse(
        pathAPI + 'api/get_chat?topic_id=' + id + '&page=1&page_size=50');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token['data']['token']
      },
    );
    if (response.statusCode == 200) {
      //print(response.statusCode);
      final Map<String, dynamic> data = convert.jsonDecode(response.body);
      // print(notinumber);
      var Data = convert.jsonDecode(response.body);

      var familyMembers = Data["data"]["data"];
      for (var familyMember in familyMembers) {
        Message message = new Message(
          msg: familyMember['text'],
          direction: familyMember['position'],
          dateTime: familyMember['send_at'],
        );
        setState(() {
          _messages.insert(0, message);
        });
      }
      if (data['code'] == 200) {
        setState(() {
          dataTimeline = data;
          setState(() {
            isLoading = false;
          });
        });

        //print(notidata.length);
      } else {
        String title = "ข้อผิดพลาดภายในเซิร์ฟเวอร์";
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => dialogDenied(
            title,
            picDenied,
            context,
          ),
        );
      }
    } else {
      final Map<String, dynamic> notinumber = convert.jsonDecode(response.body);

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialogDenied(
          notinumber['massage'],
          picDenied,
          context,
        ),
      );
    }
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));

    _gettimeline(id); //ทุกครั้งที่ทำการรีเฟรช จะดึงข้อมูลใหม่
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    //items.add((items.length+1).toString());
    _gettimeline(id);
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd hh:mm').format(time);

    return new Scaffold(
        appBar: new AppBar(
          title: const Text(
            'ห้องสนทนา',
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MessageScreen()));
              }),
        ),
        body: new Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: new Container(
              child: new Column(
                children: <Widget>[
                  //Chat list
                  new Flexible(
                    child: isLoading == true
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            header: ClassicHeader(
                              refreshStyle: RefreshStyle.Follow,
                              refreshingText: 'กำลังโหลด.....',
                              completeText: 'โหลดข้อมูลสำเร็จ',
                            ),
                            footer: CustomFooter(
                              builder: (BuildContext context, LoadStatus mode) {
                                Widget body;
                                if (mode == LoadStatus.idle) {
                                  //body =  Text("ไม่พบรายการ");
                                } else if (mode == LoadStatus.loading) {
                                  body = CircularProgressIndicator();
                                } else if (mode == LoadStatus.failed) {
                                  body = Text("Load Failed!Click retry!");
                                } else if (mode == LoadStatus.canLoading) {
                                  body = Text("release to load more");
                                } else if (mode == LoadStatus.noMore) {
                                  //body = Text("No more Data");
                                  body = Text("ไม่พบข้อมูล");
                                }
                                return Container(
                                  height: 55.0,
                                  child: Center(child: body),
                                );
                              },
                            ),
                            controller: _refreshController,
                            onRefresh: _onRefresh,
                            onLoading: _onLoading,
                            child: ListView.builder(
                              padding: new EdgeInsets.all(8.0),
                              reverse: true,
                              itemBuilder: (_, int index) => _messages[index],
                              itemCount: _messages.length,
                            ),
                          ),
                  ),
                  new Divider(height: 1.0),
                  new Container(
                      decoration:
                          new BoxDecoration(color: Theme.of(context).cardColor),
                      child: new IconTheme(
                          data: new IconThemeData(
                              color: Theme.of(context).accentColor),
                          child: new Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: new Row(
                              children: <Widget>[
                                //left send button

                                // new Container(
                                //   width: 48.0,
                                //   height: 48.0,
                                //   child: new IconButton(
                                //       icon: Image.asset(
                                //           "assets/images/send_in.png"),
                                //       onPressed: () => _sendMsg(
                                //           _textController.text,
                                //           'left',
                                //           formattedDate)),
                                // ),

                                //Enter Text message here
                                new Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: new TextField(
                                      controller: _textController,
                                      decoration: new InputDecoration.collapsed(
                                          hintText: "Enter message"),
                                    ),
                                  ),
                                ),

                                //right send button

                                new Container(
                                  margin:
                                      new EdgeInsets.symmetric(horizontal: 2.0),
                                  width: 48.0,
                                  height: 48.0,
                                  child: new IconButton(
                                      icon: Image.asset(
                                          "assets/images/send_out.png"),
                                      onPressed: () {
                                        // _sendMsg(_textController.text, 'right',
                                        //     formattedDate);
                                        _chatMember(_textController.text, id);
                                      }),
                                ),
                              ],
                            ),
                          ))),
                ],
              ),
            )));
  }

  void _sendMsg(String msg, String messageDirection, String date) {
    if (msg.length == 0) {
      // Fluttertoast.showToast(
      //     msg: "Please Enter Message",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     // timeInSecForIos: 1,
      //     backgroundColor: Colors.blue);
    } else {
      _textController.clear();
      Message message = new Message(
        msg: msg,
        direction: messageDirection,
        dateTime: date,
      );
      setState(() {
        _messages.insert(0, message);
      });
    }
  }

  _chatMember(String msg, String id) async {
    // print(id);
    // print(_textController.text);
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      isLoading = true;
    });

    var url = Uri.parse(pathAPI + 'api/chat');
    var response = await http.post(
      url,
      headers: {
        //'Content-Type': 'application/json',
        'Authorization': token['data']['token']
      },
      body: {
        'topic_id': id,
        'text': msg,
      },
    );
    if (response.statusCode == 201) {
      final Map<String, dynamic> chatdata = convert.jsonDecode(response.body);
      _textController.clear();
      setState(() {
        isLoading = false;
      });
      _gettimeline(id);
    } else {}
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    // Clean up the controller when the Widget is disposed
    _textController.dispose();
    super.dispose();
  }
}
