// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../php_data/php_data.dart';

class BarberMap extends StatefulWidget {
  final LatLng BarberLocation;
  final LatLng CustomerLocation;
  final String id;
  @override
  State<BarberMap> createState() => BarberMapState();

  const BarberMap({
    super.key,
    required this.BarberLocation,
    required this.CustomerLocation,
    required this.id,
  });
}

class BarberMapState extends State<BarberMap> {
  final Completer<GoogleMapController> _controller = Completer();
  late Location _location;
  LocationData? _currentLocation;

  late final Set<Polyline> _polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  void initState() {
    super.initState();
    _location = Location();
    _location.onLocationChanged.listen((LocationData currentLocation) {
      if (mounted) {
        setState(() {
          _currentLocation = currentLocation;
          _updateBarberLocation(
              LatLng(currentLocation.latitude!, currentLocation.longitude!));
        });
      }
    });
  }

  _updateBarberLocation(LatLng newBarberLocation) {
    if (mounted) {
      setState(() {
        _addPolyline(newBarberLocation, widget.CustomerLocation);
        _updateCameraPosition(newBarberLocation);
      });
    }
  }

  _updateCameraPosition(LatLng target) async {
    GoogleMapController? googleMapController = await _controller.future;

    // ignore: unnecessary_null_comparison
    if (mounted && googleMapController != null) {
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 16,
            target: LatLng(
              target.latitude,
              target.longitude,
            ),
          ),
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController cntlr) async {
    cntlr.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(
            widget.BarberLocation.latitude, widget.BarberLocation.longitude),
        zoom: 15,
      ),
    ));
    if (mounted) {
      setState(() {
        // _markers.add(
        //   Marker(
        //     markerId: const MarkerId('customerMarker'),
        //     position: widget.CustomerLocation,
        //     infoWindow: const InfoWindow(title: 'ลูกค้า'),
        //     icon:
        //         BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        //   ),
        // );
        _addPolyline(widget.BarberLocation, widget.CustomerLocation);
      });
    }
    if (_currentLocation != null) {
      _updateBarberLocation(
          LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!));
    }
  }

  void _addPolyline(LatLng start, LatLng end) async {
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyC-CQTJaorhqabyY6ajWq-j0y5WIqKdWeQ", //GoogleMap ApiKey
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(end.latitude, end.longitude), //last added marker
      travelMode: TravelMode.driving,
    );
    if (mounted) {
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      } else {
        // print(result.errorMessage);
      }

      Polyline polyline = Polyline(
        polylineId: const PolylineId('poly'),
        color: Colors.blue,
        width: 5,
        points: polylineCoordinates,
      );
      setState(() {
        _polylines.clear();
        _polylines.add(polyline);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แผนที่การเดินทาง'),
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
                target: widget.BarberLocation,
                zoom: 16,
              ),
              mapType: MapType.normal,
              onMapCreated: (controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              markers: {
                Marker(
                  markerId: const MarkerId('customerMarker'),
                  position: widget.CustomerLocation,
                  infoWindow: const InfoWindow(title: 'ลูกค้า'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                ),
              },
              polylines: _polylines,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 15.0),
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('แจ้งเตือน'),
                  content: const Text('คุณต้องการยืนยันว่าถึงเป้าหมายแล้ว'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'ยกเลิก',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (mounted && _currentLocation != null) {
                          double distance = calculateDistance(
                              LatLng(_currentLocation!.latitude!,
                                  _currentLocation!.longitude!),
                              widget.CustomerLocation);

                          if (distance > 1.0) {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('ข้อผิดพลาด'),
                                  content:
                                      const Text('คุณอยู่ไกลเป้าหมายเกินไป'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        'ตกลง',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            await reachedBooking(widget.id, context);
                          }
                        }
                      },
                      child: const Text(
                        'ตกลง',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          color: Colors.orangeAccent,
          textColor: Colors.black,
          child: const Text('ถึงเป้าหมาย', style: TextStyle(fontSize: 20.0)),
        ),
      ),
    );
  }
}

double calculateDistance(LatLng barberLocation, LatLng customerLocation) {
  const double earthRadius = 6371.0710; // รัศมีของโลกในหน่วยกิโลเมตร

  // แปลงพิกัดเป็นเรเดียน (radians)
  double lat1Rad = radians(barberLocation.latitude);
  double lon1Rad = radians(barberLocation.longitude);
  double lat2Rad = radians(customerLocation.latitude);
  double lon2Rad = radians(customerLocation.longitude);

  // คำนวณค่าต่างๆ
  double dLat = lat2Rad - lat1Rad;
  double dLon = lon2Rad - lon1Rad;

  // ใช้สูตร Haversine Formula เพื่อคำนวณระยะห่าง
  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  // คำนวณระยะห่างโดยคูณกับรัศมีของโลก
  double distance = earthRadius * c;
  return distance;
}

// แปลงองศาเป็นเรเดียน
double radians(double degrees) {
  return degrees * pi / 180;
}
