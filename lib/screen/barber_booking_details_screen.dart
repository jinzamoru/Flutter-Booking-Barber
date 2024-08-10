// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:math';

import 'package:finalprojectbarber/model/booking_model.dart';
import 'package:finalprojectbarber/php_data/php_data.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import '../theme/light_color.dart';
import '../theme/text_styles.dart';
import '../theme/theme.dart';

class BarBerBookingDetailScreen extends StatefulWidget {
  final BarberBookingModel model;

  const BarBerBookingDetailScreen({
    super.key,
    required this.model,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BarBerBookingDetailScreenState createState() =>
      _BarBerBookingDetailScreenState();
}

class _BarBerBookingDetailScreenState extends State<BarBerBookingDetailScreen> {
  late BarberBookingModel model;
  final Set<Marker> _markers = {};
  late double _barberLatitude = 0.0;
  late double _barberLongitude = 0.0;
  late double _customerLatitude = 0.0;
  late double _customerLongitude = 0.0;
  PolylinePoints polylinePoints = PolylinePoints();
  late final Set<Polyline> _polylines = {};

  Future<void> _getUserLocationAndAddMarker(LatLng Customerposition) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('ข้อผิดพลาด'),
            content: const Text('คุณไม่อนุญาตให้เข้าถึงตำแหน่งปัจจุบัน'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ตกลง'),
              ),
            ],
          );
        },
      );
      return;
    }
    Position position = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        _barberLatitude = position.latitude;
        _barberLongitude = position.longitude;
      });
    }
    await _addMarker(
        LatLng(_barberLatitude, _barberLongitude), Customerposition);
  }

  void _addPolyline(LatLng start, LatLng end) async {
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyC-CQTJaorhqabyY6ajWq-j0y5WIqKdWeQ", //GoogleMap ApiKey
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(end.latitude, end.longitude), //last added marker
      travelMode: TravelMode.driving,
    );
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
    if (mounted) {
      setState(() {
        _polylines.clear();
        _polylines.add(polyline);
      });
    }
  }

  Future<void> _addMarker(
      LatLng barberPosition, LatLng customerPosition) async {
    if (mounted) {
      setState(() {
        _markers.clear();
        _markers.add(Marker(
          markerId: const MarkerId('barberMarker'),
          position: barberPosition,
          infoWindow: const InfoWindow(title: 'ช่างตัดผม'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ));
        _markers.add(Marker(
          markerId: const MarkerId('customerMarker'),
          position: customerPosition,
          infoWindow: const InfoWindow(title: 'ลูกค้า'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ));
      });
    }
    _addPolyline(barberPosition, customerPosition);
  }

  @override
  void initState() {
    model = widget.model;
    super.initState();
    _customerLatitude = widget.model.location.locationLatitude;
    _customerLongitude = widget.model.location.locationLongitude;
    _getUserLocationAndAddMarker(LatLng(_customerLatitude, _customerLongitude));
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyles.title.copyWith(fontSize: 25).bold;
    if (AppTheme.fullWidth(context) < 393) {
      titleStyle = TextStyles.title.copyWith(fontSize: 23).bold;
    }
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: AppTheme.fullHeight(context),
            child: DraggableScrollableSheet(
              maxChildSize: 1.0,
              minChildSize: 1.0,
              initialChildSize: 1.0,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.only(
                    left: 19,
                    right: 19,
                    top: 16,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const BackButton(
                                  color: Colors.black,
                                ),
                                Expanded(
                                  child: Text(
                                    "${model.customer.customerFirstName} ${model.customer.customerLastName}",
                                    style: titleStyle.copyWith(
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  "สถานะ : ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  "รอยืนยัน",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.blue[400],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            thickness: .3,
                            color: LightColor.grey,
                          ),
                          Text("ข้อมูล", style: titleStyle).vP16,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.date_range,
                                color: Colors.orangeAccent,
                                size: 20,
                              ),
                              Expanded(
                                child: Text(
                                  " วันที่ ${DateFormat.MMMMd('th-TH').format(model.workScheduleStartDate)}",
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 3.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.timer_rounded,
                                color: Colors.orangeAccent,
                                size: 20,
                              ),
                              Expanded(
                                child: Text(
                                  " เวลา ${DateFormat('HH:mm').format(model.workScheduleStartDate)} น. - ${DateFormat('HH:mm').format(model.workScheduleEndDate)} น.",
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.phone_android,
                                color: Colors.orangeAccent,
                                size: 20,
                              ),
                              Expanded(
                                child: Text(
                                  model.customer.customerPhone,
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.face,
                                color: Colors.orangeAccent,
                                size: 20,
                              ),
                              Expanded(
                                child: Text(
                                  " ${model.hair.hairName}",
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 3.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.attach_money_outlined,
                                color: Colors.orangeAccent,
                                size: 20,
                              ),
                              Expanded(
                                child: Text(
                                  " รวม ${model.booking.bookingPrice} บาท",
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 3.0,
                          ),
                          Text("ที่อยู่", style: titleStyle).vP16,
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.orangeAccent,
                                size: 20,
                              ),
                              Expanded(
                                child: Text(
                                  model.location.locationName,
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 1.0,
                            height: MediaQuery.of(context).size.height * 0.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border:
                                    Border.all(color: const Color(0xffb8b5cb))),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      _customerLatitude, _customerLongitude),
                                  zoom: 15.0,
                                ),
                                markers: _markers,
                                polylines: _polylines,
                                onTap: (position) {},
                                onMapCreated: (controller) {
                                  _addMarker(
                                    LatLng(_barberLatitude, _barberLongitude),
                                    LatLng(
                                        _customerLatitude, _customerLongitude),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                height: 50,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.greenAccent,
                                ),
                                child: const Center(
                                  child: Text(
                                    "ยืนยัน",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20.0),
                                  ),
                                ),
                              ).ripple(
                                () async {
                                  await confirmBooking(
                                      model.booking.bookingId, context);
                                },
                                borderRadius: BorderRadius.circular(10),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 50,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.redAccent,
                                ),
                                child: const Center(
                                  child: Text(
                                    "ยกเลิก",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20.0),
                                  ),
                                ),
                              ).ripple(
                                () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('แจ้งเตือน'),
                                        content:
                                            const Text("คุณต้องการยกเลิกการจองคิว?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'ยกเลิก',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await cancelBooking(
                                                  model.booking.bookingId,
                                                  context);
                                            },
                                            child: const Text(
                                              'ตกลง',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ).vP16),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

int calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371.0710; // รัศมีของโลกในหน่วยกิโลเมตร

  // แปลงพิกัดเป็นเรเดียน (radians)
  double lat1Rad = radians(lat1);
  double lon1Rad = radians(lon1);
  double lat2Rad = radians(lat2);
  double lon2Rad = radians(lon2);

  // คำนวณค่าต่างๆ
  double dLat = lat2Rad - lat1Rad;
  double dLon = lon2Rad - lon1Rad;

  // ใช้สูตร Haversine Formula เพื่อคำนวณระยะห่าง
  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  // คำนวณระยะห่างโดยคูณกับรัศมีของโลก
  double distance = earthRadius * c;
  return distance.toInt();
}

// double getZoomLevel(double distance) {
//   const double mapWidth = 256.0; // ความกว้างของแผนที่ Google Maps ในหน่วยพิกเซล
//   const double zoomMax = 21.0; // Zoom Level สูงสุดที่ Google Maps รองรับ

//   // เริ่มต้นคำนวณ Zoom Level
//   double equatorLength = 40075004; // ความยาวของอีกวายร์ในหน่วยเมตร
//   double metersPerPixel = equatorLength / mapWidth; // จำนวนเมตรต่อพิกเซล

//   // คำนวณ Zoom Level ตามระยะทางที่กำหนด
//   double zoom = (math.log(distance / metersPerPixel) / math.log(2)).abs();
//   return zoom <= zoomMax
//       ? zoom
//       : zoomMax; // กำหนด Zoom Level สูงสุดเท่ากับ zoomMax
// }

double radians(double degrees) {
  return degrees * pi / 180;
}
