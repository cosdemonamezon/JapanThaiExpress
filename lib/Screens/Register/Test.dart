import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Test extends StatefulWidget {
  Test({Key key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                      name: 'name',
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: 'Fullname',
                          //border: InputBorder.none,
                          border: OutlineInputBorder(),
                          fillColor: Color(0xfff3f3f4),
                          filled: true),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                      ])),
                  SizedBox(height: 10),
                  RaisedButton(onPressed: () {
                    final isValid = _formKey.currentState.validate();
                    print(isValid);
                  }),
                  SizedBox(height: 10),
                  RaisedButton(onPressed: () {
                    _formKey.currentState.reset();
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );

    // return Column(
    //   children: [
    //     FormBuilder(
    //       key: _formKey,
    //       child: Column(
    //         children: [
    //           FormBuilderTextField(
    //               name: 'name',
    //               decoration: InputDecoration(
    //                   prefixIcon: Icon(Icons.lock),
    //                   labelText: 'Fullname',
    //                   //border: InputBorder.none,
    //                   border: OutlineInputBorder(),
    //                   fillColor: Color(0xfff3f3f4),
    //                   filled: true),
    //               validator: FormBuilderValidators.compose([
    //                 FormBuilderValidators.required(context),
    //               ])),
    //           SizedBox(height: 10),
    //           RaisedButton(onPressed: () {
    //             final isValid = _formKey.currentState.validate();
    //             print(isValid);
    //           }),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}
