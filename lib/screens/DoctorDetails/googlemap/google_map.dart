import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:psychoday/screens/DoctorDetails/doctor_detail_screen.dart';
import 'package:psychoday/utils/style.dart';

class GoogleMapDoctor extends StatefulWidget {
  const GoogleMapDoctor({super.key});

  @override
  State<GoogleMapDoctor> createState() => _GoogleMapDoctorState();
}

class _GoogleMapDoctorState extends State<GoogleMapDoctor> {
  LatLng _initialcameraposition = LatLng(36.81897, 10.16579);
  final Completer<GoogleMapController> _controller = Completer();

  //permission 
  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;


Future<void> _getLocationPermission() async {
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
}


@override
void initState() {
  super.initState();
  _getLocationPermission();
}





  void _onMapTap(LatLng position) {
    setState(() {
      _initialcameraposition = position;
    });

    print('Tapped location: ${position.latitude}, ${position.longitude}');

    void _onMapCreated(GoogleMapController _value) {
      _controller.future.then((controller) {
        controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _initialcameraposition,
            zoom: 15,
          ),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Style.primaryLight,
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(children: [
            GoogleMap(
                myLocationEnabled: true,
           myLocationButtonEnabled: true,
                onTap: _onMapTap,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(36.81897, 10.16579),
                  zoom: 15,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: _initialcameraposition != null
                    ? {
                        Marker(
                          markerId: MarkerId('tapped_position'),
                          position: _initialcameraposition,
                        )
                      }
                    : {}),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 50,
                width: double.infinity,
                margin:
                    EdgeInsets.only(right: 60, left: 10, bottom: 40, top: 40),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(_initialcameraposition);
                  },
                  color: Style.primaryLight,
                  child: Text(
                    "Set Location",
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 16,
                    ),
                  ),
                  shape: StadiumBorder(),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
