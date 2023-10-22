import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerScreen extends StatefulWidget {
@override
_LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
late GoogleMapController _mapController;
LatLng? _pickedLocation;

void _selectLocation(LatLng position) {
setState(() {
_pickedLocation = position;
});
}

void _onMapCreated(GoogleMapController controller) {
_mapController = controller;
}

void _saveLocation() {
Navigator.of(context).pop(_pickedLocation);
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text('Pick a Location'),
actions: [
IconButton(
icon: Icon(Icons.check),
onPressed: _pickedLocation == null ? null : _saveLocation,
),
],
),
body: GoogleMap(
initialCameraPosition: CameraPosition(
target: LatLng(37.422, -122.084),
zoom: 16,
),
onTap: _selectLocation,
onMapCreated: _onMapCreated,
markers: {
if (_pickedLocation != null)
Marker(
markerId: MarkerId('picked-location'),
position: _pickedLocation!,
),
},
),
);
}
}
