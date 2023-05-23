import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart'as http;


class UserDetail{
  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  var user = FirebaseFirestore.instance.collection('Users');
  //to get number of calls

  Future<void> getUser() async {
    // Get docs from collection reference
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await user.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.size;

    print("doc length $allData");
  }
  //get data by user area
 getDataByID(String value) async {
    // Get docs from collection reference
    var querySnapshot = await user.where('UID', isEqualTo: value).get();
    // Get data from docs and convert map to List
    final allData = querySnapshot;

  }
  getUserArea() async{
    var  query = await user.where("UID", isEqualTo: currentUser).get();
    var snapshot = query.docs[0];
    var data = snapshot.data();
    return data['Area'];

  }
  getUserRegion() async{
    var  query = await user.where("UID", isEqualTo: currentUser).get();
    var snapshot = query.docs[0];
    var data = snapshot.data();
    return data['Region'];
  }
  getUSeRole()async{
    var  query = await user.where("UID", isEqualTo: currentUser).get();
    var snapshot = query.docs[0];
    var data = snapshot.data();
    return data['Role'];
  }
  getUserRegionSnap() async{
    QuerySnapshot<Object?>  query = await user.where("UID", isEqualTo: currentUser).get();

    return query;
  }


}