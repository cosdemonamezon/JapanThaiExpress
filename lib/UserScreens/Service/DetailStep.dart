import 'package:flutter/material.dart';

class DetailStep extends StatefulWidget {
  DetailStep({Key key}) : super(key: key);

  @override
  _DetailStepState createState() => _DetailStepState();
}

class _DetailStepState extends State<DetailStep> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  bool checkStatus = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Step"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Stepper(
                type: stepperType,
                physics: ScrollPhysics(),
                currentStep: _currentStep,
                onStepTapped: (step) => tapped(step),
                onStepContinue:  continued,
                onStepCancel: cancel,
                controlsBuilder:
                (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                  return Row(
                    children: <Widget>[
                      FlatButton(
                        onPressed: onStepContinue,
                        child: const Text(' Message'),
                      ),
                      FlatButton(
                        onPressed: onStepCancel,
                        child: const Text('Cancel'),
                      ),
                    ],
                  );
                },
                steps: <Step>[
                  Step(
                    title: Text("1"), 
                    content: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Email Address'),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Password'),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: Text("2"), 
                    content: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Email Address'),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Password'),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: Text("3"), 
                    content: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Email Address'),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Password'),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: Text("4"), 
                    content: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Email Address'),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Password'),
                        ),
                      ],
                    ),
                  ),
                  // Step(
                  //   title: Text("Account"),
                  //   content: Column(
                  //     children: [
                  //       TextFormField(
                  //         decoration: InputDecoration(labelText: 'Email Address'),
                  //       ),
                  //       TextFormField(
                  //         decoration: InputDecoration(labelText: 'Password'),
                  //       ),
                  //     ],
                  //   ),
                  //   isActive: _currentStep >= 0,
                  //   state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
                  // ),

                  // Step(
                  //   title: Text('Address'),
                  //   content: Column(
                  //     children: [
                  //       TextFormField(
                  //         decoration: InputDecoration(labelText: 'Home Address'),
                  //       ),
                  //       TextFormField(
                  //         decoration: InputDecoration(labelText: 'Postcode'),
                  //       ),
                  //     ],
                  //   ),
                  //   isActive: _currentStep >= 0,
                  //   state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
                  // ),

                  // Step(
                  //   title: Text('Detail'),
                  //   content: Column(
                  //     children: [
                  //       TextFormField(
                  //         decoration: InputDecoration(labelText: 'Detail Address'),
                  //       ),
                  //       TextFormField(
                  //         decoration: InputDecoration(labelText: 'Detail'),
                  //       ),
                  //     ],
                  //   ),
                  //   isActive: _currentStep >= 0,
                  //   state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
                  // ),

                  // Step(
                  //   title: new Text('Mobile Number'),
                  //   content: Column(
                  //     children: <Widget>[
                  //       TextFormField(
                  //         decoration: InputDecoration(labelText: 'Mobile Number'),
                  //       ),
                  //       // RaisedButton(
                  //       //   //onPressed: onStepContinue,
                  //       //   onPressed: (){},
                  //       //   child: const Text('Next!'),
                  //       // ),
                  //     ],
                  //   ),
                  //   isActive:_currentStep >= 0,
                  //   state: _currentStep >= 3 ? StepState.complete : StepState.disabled,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step){
    setState(() => _currentStep = step);
  }

  continued(){
    _currentStep < 3 ?
        setState(() => _currentStep += 1): null;
  }
  cancel(){
    _currentStep > 0 ?
        setState(() => _currentStep -= 1) : null;
  }
}