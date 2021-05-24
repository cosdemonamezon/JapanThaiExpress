import 'package:JapanThaiExpress/UserScreens/Products/components/body.dart';
import 'package:JapanThaiExpress/UserScreens/Products/components/categorries.dart';
import 'package:JapanThaiExpress/UserScreens/Products/components/item_card.dart';
import 'package:JapanThaiExpress/UserScreens/Products/details/details_screen.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/alert.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class ProductScreen extends StatefulWidget {
  ProductScreen({Key key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool isLoading = true;
  List<dynamic> product = [];
  String tokendata = "";
  SharedPreferences prefs;
  int page = 1;
  int pageSize = 10;
  int totalResults = 0;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _getProduct();
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    //ทุกครั้งที่รีเฟรชจะเคียร์อาร์เรย์และ set page เป็น 1
    setState(() {
      product.clear();
      page = 1;
    });
    _getProduct(); //ทุกครั้งที่ทำการรีเฟรช จะดึงข้อมูลใหม่
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
        _getProduct();
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

  _getProduct() async {
    try {
      setState(() {
        page == 1 ? isLoading = true : isLoading = false;
      });
      prefs = await SharedPreferences.getInstance();
      var tokenString = prefs.getString('token');
      var token = convert.jsonDecode(tokenString);

      var url = Uri.parse(pathAPI +
          'api/app/product_page?status=&page=$page&page_size=$pageSize');
      var response = await http.get(
        url,
        headers: {
          //'Content-Type': 'application/json',
          'Authorization': token['data']['token']
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> productdata =
            convert.jsonDecode(response.body);
        setState(() {
          totalResults = productdata['data']['total'];
          product.addAll(productdata['data']['data']);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        final Map<String, dynamic> productdata =
            convert.jsonDecode(response.body);
        print(productdata['message']);
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => alert404(
            productdata['message'],
            picWanning,
            context,
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('error from backend');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: buildAppBar(),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: height,
              child: SmartRefresher(
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
                      //body = Text("ไม่พบข้อมูล");
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPaddin),
                        child: product.length > 0
                            ? GridView.builder(
                                itemCount: product.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: kDefaultPaddin,
                                  crossAxisSpacing: kDefaultPaddin,
                                  childAspectRatio: 0.75,
                                ),
                                itemBuilder: (context, index) => buildItemCard(
                                  product[index]['name'],
                                  product[index]['id'],
                                  product[index]['image'],
                                  product[index]['price'],
                                  product[index]['qty'],
                                  product[index]['description'],

                                  // press: () => Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => DetailsScreen(
                                  //       product: product[index],
                                  //     ),
                                  //   ),
                                  // ),
                                ),
                              )
                            : Center(child: Text('ไม่พบข้อมูล')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: NavigationBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xFFd73925),
      elevation: 0,
      leading: IconButton(
          onPressed: () {
            MyNavigator.goBackUserHome(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          )),

      title: Text("สินค้า"),

      // actions: <Widget>[
      //   IconButton(
      //     icon: SvgPicture.asset(
      //       "assets/icons/search.svg",
      //       // icon default color is white
      //       color: kTextColor,
      //     ),
      //     onPressed: () {},
      //   ),
      //   IconButton(
      //     icon: SvgPicture.asset(
      //       "assets/icons/cart.svg",
      //       // icon default color is white
      //       color: kTextColor,
      //     ),
      //     onPressed: () {},
      //   ),
      //   SizedBox(width: kDefaultPaddin / 2)
      // ],
    );
  }

  buildItemCard(String name, int index, String img, String price, String qty,
      String description) {
    return GestureDetector(
      onTap: () {
        var arg = {
          "id": index,
          "price": price,
          "name": name,
          "img": img,
          "description": description,
          "qty": qty
        };
        MyNavigator.goToDetailProduct(context, arg);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Card(
              elevation: 2,
              child: Container(
                padding: EdgeInsets.all(1),
                // height: 180,
                // width: 160,
                decoration: BoxDecoration(
                  //color: Color(0xFF3D82AE),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    //color: Color(0xFF3D82AE),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Image.network(
                      img,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
            child: name.length <= 10
                ? Text(
                    // products is out demo list
                    name,
                    style: TextStyle(
                        color: kTextLightColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w400),
                  )
                : Text(
                    // products is out demo list
                    name.substring(0, 20) + "...",
                    style: TextStyle(color: kTextLightColor),
                  ),
          ),
          Text(
            price + " บาท",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            "คงเหลือ " + qty + " ชิ้น",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
          )
        ],
      ),
    );
  }
}
