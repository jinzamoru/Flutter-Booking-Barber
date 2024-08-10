// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:math';

import 'package:finalprojectbarber/model/booking_model.dart';
import 'package:finalprojectbarber/model/customer_model.dart';
import 'package:finalprojectbarber/model/hair_model.dart';
import 'package:finalprojectbarber/php_data/php_data.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_manager/data_manager.dart';
import '../model/barber_model.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';
import '../theme/theme.dart';
import 'pick_location_screen.dart';

class BookingAddDetailScreen extends StatefulWidget {
  final WorkScheduleModel model;
  final HairModel hairModel;

  const BookingAddDetailScreen({
    super.key,
    required this.model,
    required this.hairModel,
  });

  @override
  _BookingAddDetailScreenState createState() => _BookingAddDetailScreenState();
}

class _BookingAddDetailScreenState extends State<BookingAddDetailScreen> {
  late WorkScheduleModel model;
  late HairModel hairModel;
  late int distance = 0;
  late int fee = 0;
  late int price = 0;
  late LocationInfo selectedLocation = LocationInfo(
      locationId: "",
      locationName: "",
      locationLatitude: 0.0,
      locationLongitude: 0.0,
      locationCusId: "");
  @override
  void initState() {
    model = widget.model;
    hairModel = widget.hairModel;
    super.initState();

    _getLocation();
  }

  _getLocation() async {
    await getAllLocation(context);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    LocationInfo defaultLocation = LocationInfo(
        locationId: "",
        locationName: "",
        locationLatitude: 0.0,
        locationLongitude: 0.0,
        locationCusId: "");

    List<LocationInfo> locationList =
        Provider.of<DataManagerProvider>(context, listen: false).getAllLocation;
    if (locationList.isNotEmpty) {
      defaultLocation = LocationInfo(
          locationId: locationList.last.locationId,
          locationName: locationList.last.locationName,
          locationLatitude: locationList.last.locationLatitude,
          locationLongitude: locationList.last.locationLongitude,
          locationCusId: locationList.last.locationCusId);
    }
    if (selectedLocation.locationName.isNotEmpty &&
        selectedLocation.locationName != "") {
      distance = calculateDistance(
          model.barber.barberLatitude,
          model.barber.barberLongitude,
          selectedLocation.locationLatitude,
          selectedLocation.locationLongitude);
      fee = calculateFeePrice(
          model.barber.barberLatitude,
          model.barber.barberLongitude,
          selectedLocation.locationLatitude,
          selectedLocation.locationLongitude);
      price = fee + hairModel.hairPrice;
      double.parse((price).toStringAsFixed(0));
    } else {
      distance = calculateDistance(
          model.barber.barberLatitude,
          model.barber.barberLongitude,
          defaultLocation.locationLatitude,
          defaultLocation.locationLongitude);
      fee = calculateFeePrice(
          model.barber.barberLatitude,
          model.barber.barberLongitude,
          defaultLocation.locationLatitude,
          defaultLocation.locationLongitude);
      price = fee + hairModel.hairPrice;
      double.parse((price).toStringAsFixed(0));
    }

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
                                    "ข้อมูลการจอง",
                                    style: titleStyle.copyWith(
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            thickness: .3,
                            color: LightColor.grey,
                          ),
                          Text("ที่อยู่", style: titleStyle).vP4,
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              boxShadow: <BoxShadow>[
                                const BoxShadow(
                                  offset: Offset(4, 4),
                                  blurRadius: 10,
                                  color: Colors.black26,
                                ),
                                BoxShadow(
                                  offset: const Offset(-3, 0),
                                  blurRadius: 15,
                                  color: LightColor.grey.withOpacity(.1),
                                )
                              ],
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 8),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.orangeAccent,
                                      size: 20,
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      onTap: () async {
                                        final selected =
                                            await Navigator.push<LocationInfo>(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                const PickLocationPage(),
                                          ),
                                        );
                                        if (selected != null) {
                                          setState(() {
                                            selectedLocation = selected;
                                          });
                                        }
                                      },
                                      trailing: const Icon(Icons.arrow_forward),
                                      contentPadding: const EdgeInsets.all(0),
                                      title: Text(
                                        selectedLocation
                                                    .locationName.isNotEmpty &&
                                                selectedLocation.locationName !=
                                                    ""
                                            ? selectedLocation.locationName
                                            : defaultLocation.locationName,
                                        style: TextStyles.titleM.bold.copyWith(
                                            color: Colors.black,
                                            fontSize: 18.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 3.0,
                          ),
                          Text("สรุปราคา", style: titleStyle).vP16,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  hairModel.hairName,
                                  style: const TextStyle(fontSize: 18.0),
                                ),
                              ),
                              Text(
                                "${hairModel.hairPrice} ฿",
                                style: const TextStyle(fontSize: 18.0),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Text(
                                "ค่าเดินทาง 5 x $distance กม.",
                                style: const TextStyle(fontSize: 18.0),
                              )),
                              Text(
                                "$fee ฿",
                                style: const TextStyle(fontSize: 18.0),
                              ),
                            ],
                          ),
                          const Divider(
                            thickness: .3,
                            color: LightColor.grey,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text("ราคารวม", style: titleStyle),
                              ),
                              Text(
                                "$price ฿",
                                style: titleStyle,
                              ),
                            ],
                          ),
                        ],
                      ).vP16),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 15.0),
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          onPressed: () async {
            String cusId =
                Provider.of<DataManagerProvider>(context, listen: false)
                    .customerProfile
                    .customerId;
            if (selectedLocation.locationName.isNotEmpty &&
                selectedLocation.locationName != "") {
              BookingInfo bookingModel = BookingInfo(
                  bookingId: "",
                  locationId: selectedLocation.locationId,
                  customerId: cusId,
                  barberId: model.workSchedule.workScheduleBarberID,
                  bookingStatus: 0,
                  hairId: hairModel.hairId,
                  workScheduleId: model.workSchedule.workScheduleID,
                  startTime: model.workSchedule.workScheduleStartDate,
                  endTime: model.workSchedule.workScheduleStartDate,
                  bookingPrice: price);
              await addBooking(bookingModel, context);
            } else {
              BookingInfo bookingModel = BookingInfo(
                  bookingId: "",
                  locationId: defaultLocation.locationId,
                  customerId: cusId,
                  barberId: model.workSchedule.workScheduleBarberID,
                  bookingStatus: 0,
                  hairId: hairModel.hairId,
                  workScheduleId: model.workSchedule.workScheduleID,
                  startTime: model.workSchedule.workScheduleStartDate,
                  endTime: model.workSchedule.workScheduleStartDate,
                  bookingPrice: price);
              await addBooking(bookingModel, context);
            }
          },
          color: Colors.orangeAccent,
          textColor: Colors.white,
          child: const Text('จองช่างตัดผม',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

int calculateFeePrice(double lat1, double lon1, double lat2, double lon2) {
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

  double distance = earthRadius * c;
  double feePrice = 5 * distance;
  return feePrice.toInt();
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

double radians(double degrees) {
  return degrees * pi / 180;
}
