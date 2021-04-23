import 'package:JapanThaiExpress/Screens/Register/OtpScreen.dart';
import 'package:JapanThaiExpress/Screens/Register/SetPin.dart';
import 'package:flutter/material.dart';

class Registration extends StatefulWidget {
  String name,lastname,password,repassword,email;
  
  Registration({Key key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  @override
  Widget build(BuildContext context) {
    String _name,_lastname,_password,_repassword,_email;
    TextEditingController password = TextEditingController();
  TextEditingController repassword = TextEditingController();
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
      ),
      body: Container(
        height: height,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: height * .01),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ชื่อ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: 'fullname',
                            //border: InputBorder.none,
                            border: OutlineInputBorder(),
                            fillColor: Color(0xfff3f3f4),
                            filled: true),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "please enter your name";
                          }
                          return null;
                        },
                        onSaved: (String name){
                          _name=name;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "นามสกุล",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: 'lastname',
                              //border: InputBorder.none,
                              border: OutlineInputBorder(),
                              fillColor: Color(0xfff3f3f4),
                              filled: true),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "please enter your lastname";
                            }
                            return null;
                          } ,
                          onSaved: (String lastname){
                          _lastname=lastname;
                        },
                        ),  
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "อีเมล์",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: 'email',
                              //border: InputBorder.none,
                              border: OutlineInputBorder(),
                              fillColor: Color(0xfff3f3f4),
                              filled: true),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "please enter your E-mail";
                            }
                            ;
                            return null;
                          },
                           onSaved: (String email){
                          _email=email;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "เบอร์โทรศัพท์",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              labelText: 'Tel',
                              //border: InputBorder.none,
                              border: OutlineInputBorder(),
                              fillColor: Color(0xfff3f3f4),
                              filled: true),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "please enter your telephone number";
                            }
                            ;
                            return null;
                          }),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "รหัสผ่าน",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        obscureText: true,
                        obscuringCharacter: "•",
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            labelText: 'Password',
                            //border: InputBorder.none,
                            border: OutlineInputBorder(),
                            fillColor: Color(0xfff3f3f4),
                            filled: true),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'กรุณากรอกรหัสผ่าน';
                          }
                          if(value.length<10){
                            return 'Please enter valid password';
                          }
                          return null;
                        },
                        onSaved: (String password){
                          _password=password;
                        },
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
                        "ยืนยันรหัสผ่าน",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        obscureText: true,
                        obscuringCharacter: "•",
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            labelText: 'Confirm Password',
                            //border: InputBorder.none,
                            border: OutlineInputBorder(),
                            fillColor: Color(0xfff3f3f4),
                            filled: true),
                        validator: (String value) {
                          
                           if (value.isEmpty) {
                            return 'กรุณายืนยันรหัสผ่าน';
                          }
                          if(password.text != repassword.text){
                            return "Password Do not match";
                          }
                          return null;
                        },
                        onSaved: (String repassword){
                          _repassword=repassword;
                        },
                      ),
                    ],
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.symmetric(vertical: 5),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text("User", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                //       SizedBox(height: 10),
                //       TextFormField(
                //         decoration: InputDecoration(
                //           //border: InputBorder.none,
                //           border: OutlineInputBorder(),
                //           fillColor: Color(0xfff3f3f4),
                //           filled: true
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(height: 5),
                // Container(
                //   margin: EdgeInsets.symmetric(vertical: 5),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text("Password", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                //       SizedBox(height: 10),
                //       TextFormField(
                //         decoration: InputDecoration(
                //           //border: InputBorder.none,
                //           border: OutlineInputBorder(),
                //           fillColor: Color(0xfff3f3f4),
                //           filled: true
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(height: 5),
                // Container(
                //   margin: EdgeInsets.symmetric(vertical: 5),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text("Confirm Password", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                //       SizedBox(height: 10),
                //       TextFormField(
                //         decoration: InputDecoration(
                //           //border: InputBorder.none,
                //           border: OutlineInputBorder(),
                //           fillColor: Color(0xfff3f3f4),
                //           filled: true
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    /*if(_formkey.currentState.validate())
                      {
                        print("successful");

                        return;
                      }else{
                        print("UnSuccessfull");
                      }*/
                    // Navigator.push(
                    //   context, MaterialPageRoute(builder: (context) => SetPin())
                    // );
                    //Navigator.push(context,
                     //   MaterialPageRoute(builder: (context) => OtpScreen()));
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
                          colors: [Color(0xffdd4b39), Color(0xffdd4b39)]),
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
