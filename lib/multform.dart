import 'package:flutter/material.dart';
class MyStepper extends StatefulWidget {
  @override
  _MyStepperState createState() => _MyStepperState();
}

class _MyStepperState extends State<MyStepper> {
  int _currentStep = 0;
  List<Step> _steps = [
    Step(
      title: Text('Step 1'),
      content: Text('Content for Step 1'),
      isActive: true,
    ),
    Step(
      title: Text('Step 2'),
      content: Container(
        height: 200.0,
        child: ListView.builder(
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('Item $index'),
              subtitle: Text('Subtitle for Item $index'),
            );
          },
        ),
      ),
      isActive: true,
    ),
    Step(
      title: Text('Step 3'),
      content: Text('Content for Step 3'),
      isActive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Stepper'),
      ),
      body: SingleChildScrollView(
        child: Stepper(
          steps: _steps,
          currentStep: _currentStep,
          onStepTapped: (int step) {
            setState(() {
              _currentStep = step;
            });
          },
          onStepContinue: () {
            setState(() {
              if (_currentStep < _steps.length - 1) {
                _currentStep++;
              } else {
                // Completed the steps
              }
            });
          },
          onStepCancel: () {
            setState(() {
              if (_currentStep > 0) {
                _currentStep--;
              } else {
                _currentStep = 0;
              }
            });
          },
        ),
      ),
    );
  }
}
