import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Profile  extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  ProfileState createState() => ProfileState();
}
class ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    getUserAttributes();
  }
  String name ="";
  String region = '';
  String userRegion = '';
  String country ='';
  String zone ='';
  String role = '';
  String email = "";

  void getUserAttributes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
    });
    name = prefs.getString("name")!;
    email = prefs.getString("email")!;
    userRegion =  prefs.getString("region")!;
    country =  prefs.getString("country")!;
    role = prefs.getString("role")!;
    zone =  prefs.getString("zone")!;

    if (kDebugMode) {
    }
    // Process the user attributes


  }
  @override
  Widget build(BuildContext context) {
    String roleName =role == "CCM" ? 'Country' : role == "Credit Analyst"||role == "ZCM" ? 'zone' : 'Region';
    String roleBase =role == "CCM" ? country : role == "Credit Analyst"||role == "ZCM" ? zone : userRegion;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [


          ClipOval(
                      child: Material(
                        color:Colors.grey.withOpacity(0.3),
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.yellow,
                          ),
                        ),
                      ),
                    ),
                    Text(name),
                    Text(email),
                    Row(

                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(onPressed: (){},child: Text("Title: $role",style: const TextStyle(color: Colors.black),)),
                        TextButton(onPressed: (){},child:Text('$roleName: $roleBase',style: const TextStyle(color: Colors.black))),

                      ],

                    ),



          const Card(
            shadowColor: Colors.amber,
            color: Colors.black,
            child: ListTile(
              title: Center(
                  child: Text("User Details",
                      style: TextStyle(fontSize: 15, color: Colors.yellow))),
              dense: true,
            ),
          ),
          ElevatedButton(onPressed: (){

          }, child: const Text("Update detail"))


        ],
      ),
    );
  }

}