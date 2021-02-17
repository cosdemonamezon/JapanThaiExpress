import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:flutter/material.dart';

class Contact extends StatefulWidget {
  Contact({Key key}) : super(key: key);

  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Us"),
      ),
      body: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height * .06),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
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
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    SizedBox(height: 10),
                    TextFormField(
                      maxLines: 7,
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
                        child: Text("Submit", style: TextStyle(fontSize: 20, color: Colors.white),),
                      ),
                    ),
                    SizedBox(height: 20),
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
                        child: Text("Call Us", style: TextStyle(fontSize: 20, color: Colors.white),),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            
          
        ),
      
      bottomNavigationBar: NavigationBar(),
    );
  }
}