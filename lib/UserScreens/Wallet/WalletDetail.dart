import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:flutter/material.dart';

class WalletDetail extends StatefulWidget {
  WalletDetail({Key key}) : super(key: key);

  @override
  _WalletDetailState createState() => _WalletDetailState();
}

class _WalletDetailState extends State<WalletDetail> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text("Wallet Detail"),
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
                  child: Text("รายการประวัติ"),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("หน้าบันทึกข้อมูล"),
                ),
              ),
              
            ]
          ),
        ),
        body: TabBarView(                  
          children: [
            Container(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                children: [
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.person, color: Color(0xffdd4b39),size: 40.0,),
                      title: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("โอนเงิน :"),
                              Text("300 Yen")
                            ],
                          ),
                          Row(
                            children: [
                              Text("18:30 น."),                                
                            ],
                          ),
                          Divider(
                            height: 2,
                            thickness: 3,
                          ),
                        ],
                      ),
                      subtitle: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("ชื่อบัญชี"),
                              Text("JP 123456789")
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("วันที่ 18/02/2021"),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                    
                ],
              ),
            ),
            Container(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                children: [
                  Icon(Icons.ac_unit)
                ],
              ),
            ),
              
          ],
        ),
        bottomNavigationBar: NavigationBar(),
      ),
      
    );
  }
}