// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickedUpLocation extends StatelessWidget {
  const PickedUpLocation(
      {super.key, required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  // ignore: no_leading_underscores_for_local_identifiers
  void _onMapCreated(GoogleMapController _cntlr) {
    CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(latitude, longitude), zoom: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition:
          CameraPosition(target: LatLng(latitude, longitude), zoom: 14),
      onMapCreated: _onMapCreated,
      markers: {
        Marker(
            markerId: const MarkerId('Home'),
            position: LatLng(latitude, longitude))
      },
      mapType: MapType.normal,
      myLocationEnabled: false,
    );
  }
}
