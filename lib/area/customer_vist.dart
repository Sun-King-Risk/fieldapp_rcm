import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fieldapp_rcm/area/location.dart';
import 'package:fieldapp_rcm/pending_task.dart';
import 'package:fieldapp_rcm/task.dart';
import 'package:fieldapp_rcm/widget/drop_down.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';

import '../utils/themes/theme.dart';



class CustomerVisit  extends StatefulWidget {

  final id;
  final angaza;
  const CustomerVisit({Key? key,required this.id,required this.angaza}) : super(key: key);
  @override
  CustomerVisitState createState() => CustomerVisitState();
}
class CustomerVisitState extends State<CustomerVisit> {
  String? phoneselected;
  String? feedbackselected;
  TextEditingController feedbackController = TextEditingController();
  TextEditingController dateInputController = TextEditingController();

  var fnumberupdate;
  var cmnumberupdate;
  var number1update;
  var name1update;
  var calltypeupdate;
  var timedateupdate;
  var duration1update;
  var accidupdate;
  var simnameupdate;
  String? promisedate = null;
  getAccountData(String angazaid) async {

    String username = 'dennis+angaza@greenlightplanet.com';
    String password = 'sunking';
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    var headers = {
      "Accept": "application/json",
      "method":"GET",
      "Authorization": '${basicAuth}',
      "account_qid" : "AC5156322",
    };
    final httpPackageUrl = Uri.https('payg.angazadesign.com', '/data/clients',{"account_qid" : "AC5156322"},
    );
    var uri = Uri.parse('https://payg.angazadesign.com/data/accounts/$angazaid');
    var response = await http.get(uri, headers: headers);
    var data = response.body;

    var dd = json.decode(response.body);
    var id = dd['client_qids'][0];

    var uriphoto = Uri.parse('https://payg.angazadesign.com/data/clients/$id');
    var responsephoto = await http.get(uriphoto, headers: headers);

    var bodyphoto = json.decode(responsephoto.body);

    var attribute = bodyphoto["attribute_values"];


    List<Map<String, dynamic>> attributes =
    attribute.cast<Map<String, dynamic>>();

    String photo = attributes
        .firstWhere((attr) => attr['name'] == 'Client Photo')['value'];
    return photo;
  }
  getPhoto(String client) async {
    String username = 'dennis+angaza@greenlightplanet.com';
    String password = 'sunking';
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    var headers = {
      "Accept": "application/json",
      "method": "GET",
      "Authorization": '${basicAuth}',
      "account_qid": "AC5156322",
    };
    var uri = Uri.parse('https://payg.angazadesign.com/data/clients/$client');
    var response = await http.get(uri, headers: headers);
    var body = json.decode(response.body);
    var attribute = body["attribute_values"];
    List<Map<String, dynamic>> attributes =
    attribute.cast<Map<String, dynamic>>();
    String photo = attributes
        .firstWhere((attr) => attr['name'] == 'Client Photo')['value'];
    return photo;
  }
  late GoogleMapController mapController;
  bool servicestatus = false;
  bool haspermission = false;
  late List<CameraDescription>? cameras;
  XFile? image;
  File? imageFile;
  late CameraController? controller;
  late LocationPermission permission;
  late Position position;
  double long =0.0, lat=0.0;
  late StreamSubscription<Position> positionStream;
  var feedback = [
    'Customer will pay',
    'System will be repossessed',
    'At the shop for replacement',
    'Product is with EO',
    'Not the owner',
  ];

  @override
  void initState() {
    checkGps();
    loadCamera();
    super.initState();
  }
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

  }
  void getImage() async{
    final file  = await ImagePicker().pickImage(source: ImageSource.camera);
    if(file?.path != null){
      setState(() {
        imageFile = File(file!.path);
      });
    }
  }
  final formKey = GlobalKey<FormState>();


  loadCamera() async {
    cameras = await availableCameras();
    if(cameras != null){
      controller = CameraController(cameras![0], ResolutionPreset.max);
      //cameras[0] = first camera, change to 1 to another camera

      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const  SnackBar(
            content: Text('No any camera found'),
          )
      );
    }
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if(servicestatus){
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Location permissions are denied'),
              ),
          );
        }else if(permission == LocationPermission.deniedForever){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permissions are permanently denied'),
            ),
          );
        }else{
          haspermission = true;
        }
      }else{
        haspermission = true;
      }

      if(haspermission){
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('GPS Service is not enabled, turn on GPS location'),
        ),
      );

    }

    /*setState(() {
      //refresh the UI
    });*/
  }
  String? reasonselected;
  getLocation() async {
    position = await Geolocator.getCurrentPosition();

    long = position.longitude;
    lat = position.latitude;

    setState(() {

      //refresh UI
    });

    LocationSettings locationSettings = const LocationSettings(
       //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings).listen((Position position) {

      long = position.longitude;
      lat = position.latitude;

      setState(() {
        //refresh UI on update
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(child: Text("denns"),),
      ),
    );
  }

}