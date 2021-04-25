import 'package:JapanThaiExpress/Screens/Register/OtpScreen.dart';
import 'package:JapanThaiExpress/Screens/Register/SetPin.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';

class Registration extends StatefulWidget {
  String name, lastname, password, repassword, email;
  Registration({Key key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

//final _formKey = GlobalKey<FormState>();

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormBuilderState>();
  static final GlobalKey<FormFieldState<String>> _searchFormKey =
      GlobalKey<FormFieldState<String>>();
  @override
  Widget build(BuildContext context) {
    String _name, _lastname, _password, _repassword, _email;
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
                FormBuilder(
                  key: _formKey,
                  child: Container(
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
                        FormBuilderTextField(
                            name: 'name',
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: 'Fullname',
                                //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                            ])),
                        SizedBox(height: 10),
                        Text(
                          "นามสกุล",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        FormBuilderTextField(
                            name: 'lname',
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: 'Lastname',
                                //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                            ])),
                        SizedBox(height: 10),
                        Text(
                          "อีเมล์",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        FormBuilderTextField(
                            name: 'email',
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                labelText: 'Email',
                                //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                            ])),
                        SizedBox(height: 10),
                        Text(
                          "เบอร์โทรศัพท์",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        FormBuilderTextField(
                            name: 'tel',
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone),
                                labelText: 'Tel',
                                //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                            ])),
                        SizedBox(height: 10),
                        Text(
                          "รหัสผ่าน",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        FormBuilderTextField(
                            name: 'password',
                            obscureText: true,
                            obscuringCharacter: "•",
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                labelText: 'Password',
                                //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                            ])),
                        SizedBox(height: 10),
                        Text(
                          "ยืนยันรหัสผ่าน",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        FormBuilderTextField(
                            name: 'confirmpassword',
                            obscureText: true,
                            obscuringCharacter: "•",
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                labelText: 'Confirm Password',
                                //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                            ])),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5),
                /*Container(
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
                      Form(child:
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
                          return null;
                        },
                        onSaved: (String password){
                          _password=password;
                        },
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
                ),*/
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

                    _formKey.currentState.save();
                    final isValid = _formKey.currentState.validate();
                    if (isValid) {
                      
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return OtpScreen();
                      }));
                    }
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
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
