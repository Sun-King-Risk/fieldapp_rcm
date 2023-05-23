

import 'package:fieldapp_rcm/services/user_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RegionData{
  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  var _region = FirebaseFirestore.instance.collection('TZ_region');
  var _area = FirebaseFirestore.instance.collection('TZ_area');

  Future<QuerySnapshot> getData() async {
    var region = await UserDetail().getUserRegion();
    return await _region.where("Region", isEqualTo: region).get();
  }
  Future<QuerySnapshot> getDataArea(String value) async {
    var region = await UserDetail().getUserRegion();
    return await _area.where("Region", isEqualTo: region).orderBy(value).get();
  }

}
class TaskData{
  var _taskregion = FirebaseFirestore.instance.collection('task');

  Future<int> CountTask(String value) async {
    var region = await UserDetail().getUserRegion();
    // Get docs from collection reference
    var querySnapshot = await _taskregion.where('task_region', isEqualTo:region).where('task_title', isEqualTo:  value).get();
    // Get data from docs and convert map to List
    int Data = querySnapshot.size;
    return Data;
  }
  Future<int> CountByStatus(String value, String status) async {
    var region = await UserDetail().getUserRegion();
    // Get docs from collection reference
    var querySnapshot = await _taskregion.where('task_region', isEqualTo: region).where('task_title', isEqualTo:  value).where('task_status', isEqualTo: status).get();
    // Get data from docs and convert map to List
    int Data = querySnapshot.size;
    return Data;
  }
  Future<int> CountPriority(String value,String priority) async {
    var region = await UserDetail().getUserRegion();
    // Get docs from collection reference
    var querySnapshot = await _taskregion.where('task_region', isEqualTo: region).where('task_title', isEqualTo:  value).where('priority', isEqualTo: priority).get();
    // Get data from docs and convert map to List
    int Data = querySnapshot.size;
    return Data;
  }
  Future<QuerySnapshot> getData(String titile,String status ) async {
    var region = await UserDetail().getUserRegion();
    return await _taskregion.where('task_title', isEqualTo:  titile).where('is_approved', isEqualTo: status).get();

  }
  Future<QuerySnapshot> PendingTaskRequest(String status) async {
    var region = await UserDetail().getUserRegion();
    return await _taskregion.where('is_approved', isEqualTo: 'Pending').get();

  }
  Future<DocumentSnapshot> getTaskById(String value) async {

    var region = await UserDetail().getUserRegion();
    DocumentReference documentReference = _taskregion.doc(value);
    Future<DocumentSnapshot> documentSnapshot = documentReference.get();
   return documentSnapshot;

  }

}