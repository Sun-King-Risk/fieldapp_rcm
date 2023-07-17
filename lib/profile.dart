import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Profile  extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  ProfileState createState() => ProfileState();
}
class ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [

          ClipOval(
                      child: Material(
                        color:Colors.grey.withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.yellow,
                          ),
                        ),
                      ),
                    ),
                    Text("Dennis Juma"),
                    Text("dennis@sunking.com"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(onPressed: (){},child: Text('+255762628707',style: TextStyle(color: Colors.black),)),
                        TextButton(onPressed: (){},child:Text('Area: Arusha',style: TextStyle(color: Colors.black))),

                      ],

                    ),



          Card(
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

          }, child: Text("Update detail"))


        ],
      ),
    );
  }

}