import 'package:flutter/material.dart';
import 'package:gps/screen/driver_screen.dart';
import 'package:gps/screen/passenger_screen.dart';
import 'package:flutter/material.dart';
import 'driver_screen.dart';
import 'rider_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: Text("Ride Sharing App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => DriverScreen()));
                },
                child: Text("Ben Sürücüyüm")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => RiderScreen(driverId: uid)));
                },
                child: Text("Ben Yolcuyum (Kendi Konumumu İzle)")),
          ],
        ),
      ),
    );
  }
}
