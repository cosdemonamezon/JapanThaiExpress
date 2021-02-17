import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:flutter/material.dart';

class ReceiveMoney extends StatefulWidget {
  ReceiveMoney({Key key}) : super(key: key);

  @override
  _ReceiveMoneyState createState() => _ReceiveMoneyState();
}

class _ReceiveMoneyState extends State<ReceiveMoney> {
  List<bool> checked = [false, true, false, false, true];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("รับโอนเงิน"),
      ),
      body: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height * .03),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Account Transfer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                       //border: InputBorder.none,
                        border: OutlineInputBorder(),
                        fillColor: Color(0xfff3f3f4),
                        filled: true
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Amount", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                       //border: InputBorder.none,
                        border: OutlineInputBorder(),
                        fillColor: Color(0xfff3f3f4),
                        filled: true
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Note", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    SizedBox(height: 10),
                    TextFormField(
                      maxLines: 4,
                      decoration: InputDecoration(
                       //border: InputBorder.none,
                        border: OutlineInputBorder(),
                        fillColor: Color(0xfff3f3f4),
                        filled: true
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              for (var i = 0; i < 1; i += 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    onChanged: i == 4
                      ? null
                      : (bool value) {
                      setState(() {
                        checked[i] = value;
                      });
                    },
                    tristate: i == 1,
                    value: checked[i],
                  ),
                  Text(
                    'Confirm Order',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(color: i == 4 ? Colors.black38 : Colors.black),
                  ),
                ],                      
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [                   
                    
                    SizedBox(height: 15),                    
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: (){
                        // Navigator.push(
                        //   context, MaterialPageRoute(builder: (context) => SetPin())
                        // );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
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
                            colors: [Color(0xffaa2e25), Color(0xffdd4b39)]
                          ),
                        ),
                        child: Text("Confirm", style: TextStyle(fontSize: 20, color: Colors.white),),
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
      bottomNavigationBar: NavigationBar(),
    );
  }
}