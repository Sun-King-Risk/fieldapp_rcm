import 'package:flutter/material.dart';

class Collection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Collection");
  }
}
class Portfolio extends StatefulWidget {
  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  @override
  Widget build(BuildContext context) {
    return Text("Portfolio");
  }
}
class Team extends StatefulWidget {
  @override
  State<Team> createState() => _TeamState();
}

class _TeamState extends State<Team> {
  late String _selectedOption;
  void initState() {
    super.initState();
    _selectedOption = '';
  }

  @override
  Widget build(BuildContext context) {
    return  DropdownButtonFormField(
        decoration: InputDecoration(labelText: 'Select an option'),
        value: "option1",
        onChanged: (newValue) {
          setState(() {
            var value = newValue!;
          });
        },
        items: [
    DropdownMenuItem(
    child: Text("Option 1"),
    value: "option1",
    ),
    DropdownMenuItem(
    child: Text("Option 2"),
    value: "option2",
    ),
    ]
    );
  }
}
class Pilot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Pilot");
  }
}
class Customer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Customer");
  }
}