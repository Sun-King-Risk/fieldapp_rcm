import 'dart:async';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class LocationMap  extends StatefulWidget {
  LocationMapState createState() => LocationMapState();
}

class  LocationMapState extends State<LocationMap> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listItems("customer_location");
    _getCurrentLocation();

  }
  List? data = [];
  List<String> region= [];
  bool isLoading = true;
  double _radius  = 30000;


  Future<LatLng> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied.';
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }
  Future<StorageItem?> listItems(key) async {
    try {
      StorageListOperation<StorageListRequest, StorageListResult<StorageItem>>
      operation = await Amplify.Storage.list(
        options: const StorageListOptions(
          accessLevel: StorageAccessLevel.guest,
          pluginOptions: S3ListPluginOptions.listAll(),
        ),
      );

      Future<StorageListResult<StorageItem>> result = operation.result;
      List<StorageItem> resultList = (await operation.result).items;
      resultList = resultList.where((file) => file.key.contains(key)).toList();
      if (resultList.isNotEmpty) {
        // Sort the files by the last modified timestamp in descending order
        resultList.sort((a, b) => b.lastModified!.compareTo(a.lastModified!));
        StorageItem latestFile = resultList.first;
        _loadCoordinates(latestFile.key);
        print(latestFile.key);
        print("Key: $key");

        return resultList.first;

      } else {
        print('No files found in the S3 bucket with key containing "$key".');
        return null;
      }

      for (StorageItem item in resultList) {
        print('Key: ${item.key}');
        print('Last Modified: ${item.lastModified}');
        // Access other properties as needed
      }

      safePrint('Got items: ${resultList.length}');
    } on StorageException catch (e) {
      safePrint('Error listing items: $e');
    }
  }
  final List<dynamic> _coordinates = [];
  List<Marker> _markers = [];
  Set<Circle> _createCircle() {
    return <Circle>{
      Circle(
        circleId: CircleId('radius'),
        center: _currentLocation,
        radius: _radius,
        fillColor: Colors.blue.withOpacity(0.3),
        strokeWidth: 0,
      ),
    };
  }
  List<LatLng> polylineCoordinates = [];
  List<LatLng> latLngList = [LatLng(-2.52783833333, 36.4846716667), LatLng(-4.095425, 36.37742), LatLng(-3.3696954, 36.6866288), LatLng(-3.307349, 36.6289648), LatLng(-3.4564848, 36.7089226), LatLng(-3.5309735, 36.117591), LatLng(-3.36875796318, 36.8862104416), LatLng(-3.3744688, 36.7568668), LatLng(-3.3220967, 36.4468417), LatLng(-3.2450547, 36.9935586),
    LatLng(-2.5516329, 36.7840539), LatLng(-2.52783833333, 36.4846716667), LatLng(-4.095425, 36.37742)];
  final Completer<GoogleMapController> _controller = Completer();
  LatLng _currentLocation = LatLng(0, 0);
  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
  }
  Future<void> _loadCoordinates(key) async {
    try{
      StorageGetUrlResult urlResult = await Amplify.Storage.getUrl(
          key: key)
          .result;

      final response = await http.get(urlResult.url);
      final jsonData = jsonDecode(response.body);
      final List<dynamic> filteredTasks = jsonData
          .where((task) => task['Region'] == 'Northern' && task['Country'] =='Tanzania'
          &&task['Location Latitudelongitude'] != null && task['Location Latitudelongitude'] != '' )
          .toList();
      print(filteredTasks);
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      LatLng currentLocation = LatLng(position.latitude, position.longitude);

      for (final task in filteredTasks) {
        final coordinate = task['Location Latitudelongitude'];
        if (coordinate != null && coordinate != '') {
          List<String> coordinatevalue = coordinate.split(',');
          if (coordinatevalue.length >= 2) {
            double latitude = double.parse(coordinatevalue[0]);
            double longitude = double.parse(coordinatevalue[1]);
            LatLng latLng = LatLng(latitude, longitude);
            double distance = await Geolocator.distanceBetween(
              currentLocation.latitude,
              currentLocation.longitude,
              latLng.latitude,
              latLng.longitude,
            );
            if (distance / 1000 <= 30) {
              latLngList.add(latLng);
            }else{
              latLngList.add(latLng);
            }
          }

        }
      }
      print(latLngList);


    }on StorageException catch (e) {
      print('Error loading coordinates: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Customers'),
          elevation: 2,
        ),
    body:FutureBuilder<LatLng>(

      future: getCurrentLocation(),

    builder: (context, snapshot)
    {
    if (snapshot.hasData) {
      LatLng currentLocation = snapshot.data!;
      _markers.add(
        Marker(
          markerId: MarkerId('currentLocation'),
          position: currentLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target:  currentLocation,
          zoom: 14,
        ),
        circles: _createCircle(),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: latLngList.map((LatLng latLng) => Marker(
          markerId: MarkerId(latLng.toString()),
          position: latLng,
        ))
            .toSet(),
        onMapCreated: (mapController) {
          _controller.complete(mapController);
        },
        polylines: {
          Polyline(
            polylineId: const PolylineId("route"),
            points: polylineCoordinates,
            color: const Color(0xFF7B61FF),
            width: 6,
          ),
        },
      );

    }
    else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }else{
      return Center(child: CircularProgressIndicator());
    }
    }
    ));
  }

}