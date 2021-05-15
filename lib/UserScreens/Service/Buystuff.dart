import 'package:JapanThaiExpress/UserScreens/Service/Service.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/alert.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' as Io;
import 'dart:convert';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Buystuff extends StatefulWidget {
  Buystuff({Key key}) : super(key: key);

  @override
  _BuystuffState createState() => _BuystuffState();
}

class _BuystuffState extends State<Buystuff> {
  List<bool> checked = [false, true, false, false, true];
  String valueChoose;
  List dropdownValue = [
    "Food",
    "Transport",
    "Personal",
    "Shopping",
    "Medical",
    "Rent",
    "Movie",
    "Salary"
  ];
  final _formKey = GlobalKey<FormBuilderState>();
  SharedPreferences prefs;
  bool isLoading = false;
  Io.File _image;
  final picker = ImagePicker();
  String img64;
  List<dynamic> listdata = []; //ประกาศตัวแปร อาร์เรย์ ไว้
  int totalResults = 0;
  int page = 1;
  int pageSize = 10;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _preOrders();
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    //ทุกครั้งที่รีเฟรชจะเคียร์อาร์เรย์และ set page เป็น 1
    setState(() {
      listdata.clear();
      page = 1;
    });
    _preOrders(); //ทุกครั้งที่ทำการรีเฟรช จะดึงข้อมูลใหม่
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    if (page < (totalResults / pageSize).ceil()) {
      if (mounted) {
        print("mounted");
        setState(() {
          page = ++page;
        });
        _preOrders();
        _refreshController.loadComplete();
      } else {
        print("unmounted");
        _refreshController.loadComplete();
      }
    } else {
      _refreshController.loadNoData();
      _refreshController.resetNoData();
    }
  }

  _preOrders() async {
    try {
      setState(() {
        page == 1 ? isLoading = true : isLoading = false;
      });
      prefs = await SharedPreferences.getInstance();
      var tokenString = prefs.getString('token');
      var token = convert.jsonDecode(tokenString);
      var url = Uri.parse(
          pathAPI + 'api/preorders?status=&page=$page&page_size=$pageSize');
      var response = await http.get(
        url,
        headers: {
          //'Content-Type': 'application/json',
          'Authorization': token['data']['token']
        },
        // body: ({
        //   'status': '',
        //   'page': page.toString(),
        //   'page_size': pageSize.toString(),
        // })
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> order = convert.jsonDecode(response.body);
        setState(() {
          totalResults = order['data']['total'];
          listdata.addAll(order['data']['data']);
          isLoading = false;
          // print(order['message']);
          // print(totalResults);
          // print("test");
          // print(listdata.length);
          // print(listdata[0]['name']);
        });
      } else {
        setState(() {
          isLoading = false;
        });
        final Map<String, dynamic> order = convert.jsonDecode(response.body);

        print("${order['message']}");
        Flushbar(
          title: '${order['message']}',
          message: 'รหัสข้อผิดพลาด : ${order['code']}',
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
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('error from backend');
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = Io.File(pickedFile.path);
        final bytes = Io.File(pickedFile.path).readAsBytesSync();
        // String base64Encode(List<int> bytes) => base64.encode(bytes);
        img64 = base64Encode(bytes);
        print(img64);
      } else {
        print('No image selected.');
      }
    });
  }

  _preorderMem(Map<String, dynamic> values) async {
    print(values);
    print(img64);
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(pathAPI + 'api/preorder_mem');
    var response = await http.post(url,
        headers: {
          //'Content-Type': 'application/json',
          'Authorization': token['data']['token']
        },
        body: ({
          'url': values['url'],
          'name': values['name'],
          'description': values['description'],
          'qty': values['qty'],
          //'note': values['note'],
          'image': "data:image/png;base64," + img64,
        }));
    if (response.statusCode == 201) {
      final Map<String, dynamic> datapreorder =
          convert.jsonDecode(response.body);
      if (datapreorder['code'] == 201) {
        print(datapreorder['message']);
        //MyNavigator.goToService(context);
        setState(() {
          isLoading = false;
        });
        String picSuccess = "assets/success.png";
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => alertPreorder(
            datapreorder['message'],
            picSuccess,
            context,
          ),
        );
      } else {
        String picSuccess = "assets/success.png";
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => alertPreorder(
            "",
            picSuccess,
            context,
          ),
        );
      }
    } else {
      String picSuccess = "assets/success.png";
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => alertPreorder(
          "",
          picSuccess,
          context,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text("รับฝากซื้อสินค้า"),
              leading: IconButton(
                  onPressed: () {
                    //Navigator.pop(context);
                    //MyNavigator.goToService(context);
                    Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Service()));
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                  )),
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
                        child: Text("รายการ"),
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("ฝากซื้อสินค้า"),
                      ),
                    ),
                  ])),
          body: TabBarView(
            children: [
              isLoading == true
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
                          itemCount: listdata.length,
                          itemBuilder: (BuildContext context, int index) {
                            return buildCard(
                              listdata[index]['name'],
                              listdata[index]['code'] == null
                                  ? 'ไม่มีข้อมูล'
                                  : listdata[index]['code'],
                              listdata[index]['description'] == null
                                  ? 'ไม่มีข้อมูล'
                                  : listdata[index]['description'],
                              listdata[index]['price'] == null
                                  ? 'ไม่มีข้อมูล'
                                  : listdata[index]['price'],
                              listdata[index]['track_jp'] == null
                                  ? 'ไม่มีข้อมูล'
                                  : listdata[index]['track_jp'],
                              listdata[index]['image'] == null
                                  ? "https://picsum.photos/200/300"
                                  : listdata[index]['image'],
                            );
                          }),
                    ),
              //tab 2
              Container(
                height: height,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: FormBuilder(
                    key: _formKey,
                    initialValue: {
                      'url': '',
                      'name': '',
                      'description': '',
                      'qty': '',
                      //'note': '',
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: height * .04),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ลิ้งค์ URL สินค้า *",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(height: 10),
                              FormBuilderTextField(
                                name: 'url',
                                decoration: InputDecoration(
                                    //border: InputBorder.none,
                                    border: OutlineInputBorder(),
                                    fillColor: Color(0xfff3f3f4),
                                    filled: true),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(context,
                                      errorText: 'กรุณาใส่ url สินค้า'),
                                  // FormBuilderValidators.numeric(context),
                                  // FormBuilderValidators.max(context, 70),
                                ]),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ชื่อสินค้า *",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(height: 10),
                              FormBuilderTextField(
                                name: 'name',
                                decoration: InputDecoration(
                                    //border: InputBorder.none,
                                    border: OutlineInputBorder(),
                                    fillColor: Color(0xfff3f3f4),
                                    filled: true),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(context,
                                      errorText: 'กรุณาใส่ชื่อสินค้า'),
                                  // FormBuilderValidators.numeric(context),
                                  // FormBuilderValidators.max(context, 70),
                                ]),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "รายละเอียด",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(height: 10),
                              FormBuilderTextField(
                                name: 'description',
                                maxLines: 3,
                                decoration: InputDecoration(
                                    //border: InputBorder.none,
                                    border: OutlineInputBorder(),
                                    fillColor: Color(0xfff3f3f4),
                                    filled: true),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "จำนวน *",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(height: 10),
                              FormBuilderTextField(
                                keyboardType: TextInputType.number,
                                name: 'qty',
                                decoration: InputDecoration(
                                    //border: InputBorder.none,
                                    border: OutlineInputBorder(),
                                    fillColor: Color(0xfff3f3f4),
                                    filled: true),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(context,
                                      errorText: 'กรุณาใส่จำนวนสินค้า'),
                                  // FormBuilderValidators.numeric(context),
                                  // FormBuilderValidators.max(context, 70),
                                ]),
                              ),
                            ],
                          ),
                        ),
                        // Container(
                        //   margin: EdgeInsets.symmetric(vertical: 5),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text("Note", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                        //       SizedBox(height: 10),
                        //       FormBuilderTextField(
                        //         name: 'note',
                        //         maxLines: 3,
                        //         decoration: InputDecoration(
                        //         //border: InputBorder.none,
                        //           border: OutlineInputBorder(),
                        //           fillColor: Color(0xfff3f3f4),
                        //           filled: true
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Center(
                            child: Container(
                              height: 180,
                              width: 180,
                              //color: Colors.red,
                              child: _image == null
                                  ? Image.asset("assets/images/nopic.png")
                                  : Image.file(
                                      _image,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   crossAxisAlignment: CrossAxisAlignment.end,
                        //   children: [
                        //     Container(
                        //       width: width * 0.68,
                        //       margin: EdgeInsets.symmetric(vertical: 5),
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Text(
                        //             "โค๊ดโปรโมชั่น",
                        //             style: TextStyle(
                        //                 fontWeight: FontWeight.bold,
                        //                 fontSize: 15),
                        //           ),
                        //           SizedBox(height: 10),
                        //           FormBuilderTextField(
                        //             name: 'code',
                        //             decoration: InputDecoration(
                        //                 //border: InputBorder.none,
                        //                 border: OutlineInputBorder(),
                        //                 fillColor: Color(0xfff3f3f4),
                        //                 filled: true),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //     Container(
                        //       width: width * 0.2,
                        //       margin: EdgeInsets.symmetric(vertical: 5),
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.end,
                        //         mainAxisAlignment: MainAxisAlignment.end,
                        //         children: [
                        //           //SizedBox(height: 3),
                        //           GestureDetector(
                        //             onTap: () {

                        //             },
                        //             child: Container(
                        //               padding:
                        //                   EdgeInsets.symmetric(vertical: 15),
                        //               alignment: Alignment.center,
                        //               decoration: BoxDecoration(
                        //                 borderRadius: BorderRadius.all(
                        //                     Radius.circular(5)),
                        //                 boxShadow: <BoxShadow>[
                        //                   BoxShadow(
                        //                       color: Colors.grey.shade200,
                        //                       offset: Offset(2, 4),
                        //                       blurRadius: 5,
                        //                       spreadRadius: 2)
                        //                 ],
                        //                 gradient: LinearGradient(
                        //                     begin: Alignment.centerLeft,
                        //                     end: Alignment.centerRight,
                        //                     colors: [
                        //                       Color(0xffdd4b39),
                        //                       Color(0xffdd4b39)
                        //                     ]),
                        //               ),
                        //               child: Text(
                        //                 "ใช้",
                        //                 style: TextStyle(
                        //                     fontSize: 20, color: Colors.white),
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     Text("ค่าบริการ"),
                        //   ],
                        // ),
                        // Container(
                        //   width: width * 0.9,
                        //   height: height * 0.09,
                        //   color: Colors.blue[50],
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Padding(
                        //         padding:
                        //             const EdgeInsets.symmetric(horizontal: 45),
                        //         child: Text("300 บาท"),
                        //       ),
                        //       Center(
                        //         child: VerticalDivider(
                        //           thickness: 1,
                        //           color: Colors.grey,
                        //         ),
                        //       ),
                        //       Padding(
                        //         padding:
                        //             const EdgeInsets.symmetric(horizontal: 20),
                        //         child: Row(
                        //           children: [
                        //             Text("รายละเอียด"),
                        //             IconButton(
                        //                 icon: Icon(Icons.keyboard_arrow_up),
                        //                 onPressed: () {})
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        SizedBox(
                          height: 5,
                        ),

                        // Container(
                        //   width: width * 0.9,
                        //   height: height * 0.20,
                        //   color: Colors.blue[50],
                        //   child: Column(
                        //     children: [
                        //       Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Padding(
                        //             padding: const EdgeInsets.symmetric(
                        //                 horizontal: 20),
                        //             child: Text("ค่าขนส่ง"),
                        //           ),
                        //           Padding(
                        //             padding: const EdgeInsets.symmetric(
                        //                 horizontal: 20),
                        //             child: Text("30 บาท"),
                        //           ),
                        //         ],
                        //       ),
                        //       Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Padding(
                        //             padding: const EdgeInsets.symmetric(
                        //                 horizontal: 20),
                        //             child: Text("ไปกลับ"),
                        //           ),
                        //           Padding(
                        //             padding: const EdgeInsets.symmetric(
                        //                 horizontal: 20),
                        //             child: Text("0.0 บาท"),
                        //           ),
                        //         ],
                        //       ),
                        //       Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Padding(
                        //             padding: const EdgeInsets.symmetric(
                        //                 horizontal: 20),
                        //             child: Text("ระยะทาง"),
                        //           ),
                        //           Padding(
                        //             padding: const EdgeInsets.symmetric(
                        //                 horizontal: 20),
                        //             child: Text("0   km"),
                        //           ),
                        //         ],
                        //       ),
                        //       SizedBox(
                        //         height: 15,
                        //       ),
                        //       Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Padding(
                        //             padding: const EdgeInsets.symmetric(
                        //                 horizontal: 20),
                        //             child: Text("ยอดรวม"),
                        //           ),
                        //           Padding(
                        //             padding: const EdgeInsets.symmetric(
                        //                 horizontal: 20),
                        //             child: Text("30 บาท"),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    setState(() {
                                      isLoading = true;
                                    });
                                    //print(_formKey.currentState.value);
                                    _preorderMem(_formKey.currentState.value);
                                  } else {}
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.grey.shade200,
                                          offset: Offset(2, 4),
                                          blurRadius: 5,
                                          spreadRadius: 2)
                                    ],
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xffdd4b39),
                                          Color(0xffdd4b39)
                                        ]),
                                  ),
                                  child: isLoading == true
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : Text(
                                          "ยืนยัน",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                ),
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: NavigationBar(),
        ));
  }

  Card buildCard(String title, String title2, String title3, String title4,
      String title5, String image) {
    return Card(
      child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(image),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Text(
                title2,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Text(
                title3,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Text(
                "ราคา：" + title4,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Text(
                "tag：" + title5,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14,
                ),
              )
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_right_outlined),
                color: Colors.orange[900],
                iconSize: 30,
                onPressed: () {
                  //MyNavigator.goToTimelineOrders(context);
                },
              ),
            ],
          ),
          /*subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MaterialButton(
                onPressed: () {
                  //MyNavigator.goToTimelineOrders(context);
                },
                color: primaryColor,
                child: Text(
                  "ดูเพิ่ม",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          )*/),
    );
  }
}
