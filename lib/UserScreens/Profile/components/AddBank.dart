import 'package:JapanThaiExpress/constants.dart';
import 'package:flutter/material.dart';

class AddBank extends StatefulWidget {
  AddBank({Key key}) : super(key: key);

  @override
  _AddBankState createState() => _AddBankState();
}

class _AddBankState extends State<AddBank> {
  String _selectedItem = '';
  bool _checkbox = false;
  bool _checkboxListTile = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("เพิ่มบัญชี"),
      ),
      body: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [                    
                    SizedBox(height: 20),
                    TextFormField(
                      autofocus: true,                      
                      decoration: InputDecoration(                        
                        //border: InputBorder.none,
                        hintText: "ชื่อบัญชี",
                        border: OutlineInputBorder(
                          borderRadius:BorderRadius.circular(30.0)
                        ),
                        fillColor: Color(0xfff3f3f4),
                        filled: true
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      autofocus: true, 
                      keyboardType: TextInputType.number,                     
                      decoration: InputDecoration(                        
                        //border: InputBorder.none,
                        hintText: "หมายเลขบัญชี",
                        border: OutlineInputBorder(
                          borderRadius:BorderRadius.circular(30.0)
                        ),
                        fillColor: Color(0xfff3f3f4),
                        filled: true
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          width: 300,
                          child: TextFormField(
                            enabled: false,
                            //autofocus: true, 
                            //keyboardType: TextInputType.number,                     
                            decoration: InputDecoration( 
                              // suffixIcon: Container(
                              //   width: 60,
                              //   child: IconButton(
                              //     icon: Icon(Icons.expand_more_outlined, size: 35,),
                              //     onPressed: () {
                              //       _onButtonPressed();
                              //     }                
                              //   ),
                              // ),                   
                              //border: InputBorder.none,
                              hintText: "เลือกธนาคาร",
                              border: OutlineInputBorder(
                                borderRadius:BorderRadius.circular(30.0)
                              ),
                              fillColor: Color(0xfff3f3f4),
                              filled: true
                            ),
                          ),
                        ),
                        Container(
                          height: 60,
                          width: 70,  
                          decoration: BoxDecoration(
                            color: Colors.red,
                            border: Border.all(color: Colors.blueAccent),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(18),
                              bottomLeft: Radius.circular(18),
                              bottomRight: Radius.circular(18),
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.more_horiz), 
                            onPressed: (){
                              _onButtonPressed();
                            }
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onButtonPressed(){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context){
        return Container(
          height: MediaQuery.of(context).size.height * 0.80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.person),
                title: Text("ธนาคารกรุงไทย"),
                trailing: Checkbox(
                  value: _checkbox,
                  onChanged: (bool value){
                    setState(() {
                      _checkbox = value;
                    });
                  }
                ),
              ),
              GestureDetector(
                onTap: () => _selectItem('testttttttt'),
                child: Container(
                  height: 30,
                  width: 100,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  void _selectItem(String name){
    //Navigator.pop(context);
    setState(() {
      _selectedItem = name;
    });
    print(_selectedItem);
  }

}