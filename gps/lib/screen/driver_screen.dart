import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DriverScreen extends StatefulWidget {
  @override
  _DriverScreenState createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  StreamSubscription<Position>? _positionStream;
  final databaseRef = FirebaseDatabase.instance.ref("drivers");

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
  }

  void _startLocationUpdates() async {
    await Geolocator.requestPermission();

    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // 5 metre değişince güncelle
      ),
    ).listen((Position position) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      databaseRef.child(uid).set({
        "lat": position.latitude,
        "lng": position.longitude,
        "timestamp": DateTime.now().millisecondsSinceEpoch
      });
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Driver Location Sender")),
      body: Center(child: Text("Konumunuz gerçek zamanlı gönderiliyor...")),
    );
  }
}
