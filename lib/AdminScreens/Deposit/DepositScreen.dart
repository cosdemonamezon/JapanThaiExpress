import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:flutter/material.dart';

class DepositScreen extends StatefulWidget {
  DepositScreen({Key key}) : super(key: key);

  @override
  _DepositScreenState createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  List<bool> checked = [true, true, false, false, true];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Deposit / Withdraw"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Account Transfer"),
                    SizedBox(height: 10,),
                    TextFormField(
                      //initialValue: '0.29 / 1 Bath',
                      decoration: InputDecoration(
                        //labelText: 'Label text',
                        //errorText: 'Error message',
                        hintText: "Account",
                        border: OutlineInputBorder(),
                        
                      ),
                    ),
                    SizedBox(height: 30,),
                    Text("Amount"),
                    SizedBox(height: 10,),
                    TextFormField(
                      //initialValue: '0.32 / 1 Bath',
                      decoration: InputDecoration(
                        //labelText: 'Label text',
                        //errorText: 'Error message',
                        hintText: "Qty",
                        border: OutlineInputBorder(),
                        
                      ),
                    ),
                    SizedBox(height: 30,),
                    Text("Note"),
                    SizedBox(height: 10,),
                    TextFormField(
                      //initialValue: '0.32 / 1 Bath',
                      maxLines: 5,
                      decoration: InputDecoration(
                        //labelText: 'Label text',
                        //errorText: 'Error message',
                        hintText: "detail",
                        border: OutlineInputBorder(),
                        
                      ),
                    ),
                    SizedBox(height: 20,),
                    for (var i = 0; i < 1; i += 1)
                    Row(
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
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
                    SizedBox(height: 40,),
                    RaisedButton(
                      onPressed: () {},
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF0D47A1),
                              Color(0xFF1976D2),
                              Color(0xFF42A5F5),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Text(
                            "Confirm", style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navigation(),
    );
  }
}