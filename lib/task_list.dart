import 'package:flutter/material.dart';

class Collection extends StatelessWidget {
  const Collection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Collection");
  }
}
class Portfolio extends StatefulWidget {
  const Portfolio({super.key});

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  @override
  Widget build(BuildContext context) {
    return const Text("Portfolio");
  }
}
class Team extends StatefulWidget {
  const Team({super.key});

  @override
  State<Team> createState() => _TeamState();
}

class _TeamState extends State<Team> {
  late String _selectedOption;
  @override
  void initState() {
    super.initState();
    _selectedOption = '';
  }

  @override
  Widget build(BuildContext context) {
    return  DropdownButtonFormField(
        decoration: const InputDecoration(labelText: 'Select an option'),
        value: "option1",
        onChanged: (newValue) {
          setState(() {
            var value = newValue!;
          });
        },
        items: const [
    DropdownMenuItem(
    value: "option1",
    child: Text("Option 1"),
    ),
    DropdownMenuItem(
    value: "option2",
    child: Text("Option 2"),
    ),
    ]
    );
  }
}
class Pilot extends StatelessWidget {
  const Pilot({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Pilot");
  }
}
class Customer extends StatelessWidget {
  const Customer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Customer");
  }
}