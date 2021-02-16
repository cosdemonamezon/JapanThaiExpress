import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:flutter/material.dart';

class MaintainScreen extends StatefulWidget {
  MaintainScreen({Key key}) : super(key: key);

  @override
  _MaintainScreenState createState() => _MaintainScreenState();
}

class _MaintainScreenState extends State<MaintainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Maintain Rate"),
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
                    Text("Update Yen"),
                    SizedBox(height: 10,),
                    TextFormField(
                      initialValue: '0.29 / 1 Bath',
                      decoration: InputDecoration(
                        //labelText: 'Label text',
                        //errorText: 'Error message',
                        hintText: "",
                        border: OutlineInputBorder(),
                        
                      ),
                    ),
                    SizedBox(height: 30,),
                    Text("Update Yen for Auction"),
                    SizedBox(height: 10,),
                    TextFormField(
                      initialValue: '0.32 / 1 Bath',
                      decoration: InputDecoration(
                        //labelText: 'Label text',
                        //errorText: 'Error message',
                        hintText: "",
                        border: OutlineInputBorder(),
                        
                      ),
                    ),
                    SizedBox(height: 250,),
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
                            "Update", style: TextStyle(fontSize: 20),
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