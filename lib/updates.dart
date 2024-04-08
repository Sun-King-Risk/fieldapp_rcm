import 'package:flutter/material.dart';

import 'dailyupdate.dart';
import 'insight.dart';
class Updates extends StatelessWidget {
  const Updates({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const TabBar(tabs: [
                Tab(
                  text: "Insight",
                ),
                //Tab(text: "Agent"),
              ]),
    Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        child: const TabBarView(
          children: [
           Insight(),
          ],
        ),

      ),
    )
            ]

        )

    );
  }
}

