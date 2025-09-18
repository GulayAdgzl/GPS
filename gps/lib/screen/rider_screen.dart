import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

class RiderScreen extends StatefulWidget {
  final String driverId;
  RiderScreen({required this.driverId});

  @override
  _RiderScreenState createState() => _RiderScreenState();
}

class _RiderScreenState extends State<RiderScreen> {
  late GoogleMapController _mapController;
  final databaseRef = FirebaseDatabase.instance.ref("drivers");
  Marker? driverMarker;

  @override
  void initState() {
    super.initState();
    _listenDriverLocation();
  }

  void _listenDriverLocation() {
    databaseRef.child(widget.driverId).onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        final lat = data["lat"] as double;
        final lng = data["lng"] as double;

        final newMarker = Marker(
          markerId: MarkerId(widget.driverId),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        );

        setState(() {
          driverMarker = newMarker;
        });

        // Kamera hareketi
        _mapController.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rider Map View")),
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: LatLng(39.9, 32.8), zoom: 12),
        onMapCreated: (controller) => _mapController = controller,
        markers: driverMarker != null ? {driverMarker!} : {},
      ),
    );
  }
}
