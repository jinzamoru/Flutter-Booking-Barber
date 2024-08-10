import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/customer_model.dart';
import '../php_data/php_data.dart';

class CustomerMap extends StatefulWidget {
  final LocationInfo cuslocation;
  @override
  State<CustomerMap> createState() => CustomerMapState();

  const CustomerMap({
    super.key,
    required this.cuslocation,
  });
}

class CustomerMapState extends State<CustomerMap> {
  final Completer<GoogleMapController> _controller = Completer();

  TextEditingController nameController = TextEditingController();
  final Set<Marker> _markers = {};
  late LocationInfo model;
  double _latitude = 0.0;
  double _longitude = 0.0;
  @override
  void initState() {
    model = widget.cuslocation;
    super.initState();
    _latitude = model.locationLatitude;
    _longitude = model.locationLongitude;
    nameController.text = model.locationName;
  }

  Future<void> _addMarker(LatLng position) async {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('Address'),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }

  void _updateMarkerPosition(LatLng position) {
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
      _addMarker(position);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขที่อยู่'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(_latitude, _longitude),
                  zoom: 15,
                ),
                mapType: MapType.normal,
                onMapCreated: (controller) {
                  _controller.complete(controller);
                  _addMarker(LatLng(_latitude, _longitude));
                },
                myLocationEnabled: true,
                zoomGesturesEnabled: true,
                onTap: (position) {
                  _updateMarkerPosition(position);
                },
                gestureRecognizers: Set()
                  ..add(Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer())),
                markers: _markers),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: nameController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'ที่อยู่',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 15.0),
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          onPressed: () async {
            final locationModel = LocationInfo(
              locationId: model.locationId,
              locationLatitude: _latitude,
              locationLongitude: _longitude,
              locationName: nameController.text,
              locationCusId: model.locationCusId,
            );
            await updateLocation(locationModel, context);
          },
          color: Colors.orangeAccent,
          textColor: Colors.black,
          child: const Text('ยืนยันตำแหน่ง', style: TextStyle(fontSize: 20.0)),
        ),
      ),
    );
  }
}
