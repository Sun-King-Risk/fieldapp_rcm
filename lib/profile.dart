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
          PopupMenuButton(
            icon: const Icon(Icons.language, color: Colors.black),
            itemBuilder: (BuildContext context)   =>[
              PopupMenuItem(
                value: "hi",
                child: const Icon(Icons.language, color: Colors.black),
              ),
              PopupMenuItem(
                  value: "hi",
                  child: const Icon(Icons.language, color: Colors.black),
              ),
              PopupMenuItem(
                  value: "hi",
                  child: const Icon(Icons.language, color: Colors.black),
              ),
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
            showDialog(
              context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Update Detail'),
                content: Expanded(
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter your Name',
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter your Role',
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter your Area',
                        ),

                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter your Country',
                        ),
                      ),
                    ],
                  ),
                ),
                  actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('Cancel'),
                  ),
              ElevatedButton(
                onPressed: () {
                  // Handle the input here, for example, print it
                  print('Detail updated:');
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Update'),
              )
                  ]
              );
            }
            );

          }, child: const Text("Update detail"))


        ],
      ),
    );
  }

}