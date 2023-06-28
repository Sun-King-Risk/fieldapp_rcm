import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMap  extends StatefulWidget {
  LocationMapState createState() => LocationMapState();
}
class  LocationMapState extends State<LocationMap> {
  late GoogleMapController mapController;
  static const LatLng sourceLocation = LatLng(-3.4066411, 36.7039782);
  final LatLng _center = const LatLng(45.521563, -122.677433);
  final Completer<GoogleMapController> _controller = Completer();
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  List<LatLng> polylineCoordinates = [];
  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyCxmwQB8Kkkvj2I4rLpsreA54-XAlvUryk', // Your Google Map Key
      PointLatLng(-3.4066411, 36.7039782),
      PointLatLng(-3.4066411, 36.7039782),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
            (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Maps Sample App'),
          elevation: 2,
        ),
    body: GoogleMap(
      initialCameraPosition: CameraPosition(
        target:  _center,
        zoom: 10,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      markers: {
        Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          markerId: const MarkerId("destination"),
          infoWindow: InfoWindow(title:" widget.name"),
          position:_center,
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
    );
  }

}