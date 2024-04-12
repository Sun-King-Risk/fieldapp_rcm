



import '../updates.dart';
import 'appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../utils/themes/theme.dart';
import '../../task.dart';
import '../../dashboard.dart';

class NavPage extends StatefulWidget{
  const NavPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return NavPagePageState();
  }

}
class NavPagePageState extends State<NavPage> {


  @override
  void dispose() {
    super.dispose();
  }
  late String? tokenId;
  @override
  void initState(){
    super.initState();
  }
  int _selectedIndex = 0;
  final List<Widget> _tabs = <Widget>[
    Home(),
    const Task(),
    const Updates(),
    /*AreaDashboard(),
    Customer(),*/
  ];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar:SKAppBar(height: 60, context: context,),
      body: Container(
          child: _tabs.elementAt(_selectedIndex)),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColor.appColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(

              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: AppColor.appColor,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.black87,
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.task,
                  text: 'Task',
                ),
                GButton(
                  icon: Icons.access_time,
                  text: 'Update',
                ),
              ],
              onTabChange: (index){
                setState(() {
                  _selectedIndex= index;
                });
              },

            ),
          ),
        ),
      ),
    );
  }
}

