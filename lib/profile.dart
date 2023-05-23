import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Profile  extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  ProfileState createState() => ProfileState();
}
class ProfileState extends State<Profile> {
  var currentUser = FirebaseAuth.instance.currentUser;
  final collectionRef = FirebaseFirestore.instance.collection('Users');
  late final data ='';
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
          StreamBuilder(
            stream: collectionRef.where('UID',isEqualTo:currentUser!.uid).get().asStream() ,
            builder: (context, snapshot){

              if(snapshot.hasData){
                String? email;
                for (UserInfo userInfo in currentUser!.providerData) {
                  email = userInfo.email;
                }
                var data = snapshot.data!.docs[0];
                return Column(
                  children: [
                    currentUser!.photoURL != null
                        ? ClipOval(
                      child: Material(
                        color: Colors.blue.withOpacity(0.3),
                        child: Image.network(
                          currentUser!.photoURL!,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )
                        : ClipOval(
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
                    Text("${currentUser?.displayName}"),
                    Text("${email}"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(onPressed: (){},child: Text('Phone: ${data['Phone Number']}',style: TextStyle(color: Colors.black),)),
                        TextButton(onPressed: (){},child:Text('Area: ${data['Area']}',style: TextStyle(color: Colors.black))),

                      ],

                    ),

                  ],
                );
              }return Column(
              children: const [
                CircularProgressIndicator(),
                Text("Loading data...")
              ],
              );
            }

          ) ,



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