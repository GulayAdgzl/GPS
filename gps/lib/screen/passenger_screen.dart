import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PassengerScreen extends StatefulWidget {
  const PassengerScreen({super.key});

  @override
  State<PassengerScreen> createState() => _PassengerScreenState();
}

class _PassengerScreenState extends State<PassengerScreen> {
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child("drivers/driver1");

  GoogleMapController? _mapController;
  Marker? _driverMarker;
  StreamSubscription<DatabaseEvent>? _driverStream;

  static const CameraPosition _initialPos =
      CameraPosition(target: LatLng(39.9208, 32.8541), zoom: 12); // Ankara

  @override
  void initState() {
    super.initState();
    _listenDriverLocation();
  }

  void _listenDriverLocation() {
    _driverStream = _dbRef.onValue.listen((event) {
      if (event.snapshot.value == null) return;
      final data = Map<String, dynamic>.from(
          event.snapshot.value as Map<dynamic, dynamic>);

      final double lat = data["latitude"];
      final double lng = data["longitude"];

      final LatLng pos = LatLng(lat, lng);

      setState(() {
        _driverMarker = Marker(
          markerId: const MarkerId("driver"),
          position: pos,
          infoWindow: const InfoWindow(title: "Sürücü"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        );
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLng(pos),
      );
    });
  }

  @override
  void dispose() {
    _driverStream?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yolcu Haritası")),
      body: GoogleMap(
        initialCameraPosition: _initialPos,
        markers: _driverMarker != null ? {_driverMarker!} : {},
        onMapCreated: (controller) => _mapController = controller,
      ),
    );
  }
}
