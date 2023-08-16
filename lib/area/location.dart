
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googleapis/youtube/v3.dart';
import 'dart:async';
import 'package:location/location.dart';




class CustomerLocation  extends StatefulWidget {
  final id;
  final customerLocation;
  final name;
  const CustomerLocation({Key? key,required this.id,required this.customerLocation, required this.name}) : super(key: key);
  @override
  CustomerLocationState createState() => CustomerLocationState();
}
class CustomerLocationState extends State<CustomerLocation> {
  late GoogleMapController mapController;
  dynamic location;

  late final latlong = widget.customerLocation.split(",");
  late double lat = 0.0;
  late double long =  0.0;


  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(-3.4066411, 36.7039782);
  late GeoPoint destination = GeoPoint();
  static const LatLng sourceL= LatLng(-2.4066411, 30.7039782);
  LocationData? currentLocation;
  @override
  void initState() {
    super.initState();

    location = widget.customerLocation;

    if(location is GeoPoint){
      destination = widget.customerLocation;
    }else if(location is LatLng){
      lat = double.parse(latlong[0]);
      long = double.parse(latlong[1]);

    }else{
      lat = double.parse(latlong[0]);
      long = double.parse(latlong[1]);
    }
    setState(() {

    });
  }
  void _onMapCreat(GoogleMapController controller) {
    mapController = controller;

  }
  Marker _destination = Marker(
    markerId: MarkerId('destination'),
    position: LatLng(-4.211560, 35.748932),
    infoWindow: InfoWindow(title: 'Destination'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  );
  List<LatLng> polylineCoordinates = [];


  late LatLng _currentPosition;
  bool _isLoading = true;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target:  LatLng(0.0,0.0),
          zoom: 10,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: {
          Marker(
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            markerId: const MarkerId("destination"),
            infoWindow: InfoWindow(title: widget.name),

          ),
        },
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
      )
      /*
      GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(destination.latitude,destination.longitude),
          zoom: 11.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: { _destination, Marker(
          markerId: const MarkerId("source"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: LatLng(destination.latitude,destination.longitude),
        ), },
        polylines: {
          Polyline(
            polylineId: PolylineId('route'),
            color: Colors.blue,
            width: 5,
            points: polylineCoordinates,
          ),
        },
      ),*/
    );
  }
  
  
}