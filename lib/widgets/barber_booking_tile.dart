// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:finalprojectbarber/model/booking_model.dart';
import 'package:finalprojectbarber/screen/barber_fare_booking_screen.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:finalprojectbarber/widgets/barber_google_map.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../screen/barber_booking_details_screen.dart';
import '../screen/barber_payment_booking_screen.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';

Widget BarberBookingTile(BarberBookingModel model, BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              title: Text(
                "${model.customer.customerFirstName} ${model.customer.customerLastName}",
                style: TextStyles.titleM.bold
                    .copyWith(color: Colors.black, fontSize: 18.0),
              ),
              subtitle: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.date_range,
                            size: 15,
                            color: Colors.orangeAccent,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            "วันที่ ${DateFormat.MMMMd('th-TH').format(model.workScheduleStartDate)}",
                            style:
                                TextStyles.bodySm.subTitleColor.bold.copyWith(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.timer_rounded,
                            size: 15,
                            color: Colors.orangeAccent,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            "เวลา ${DateFormat('HH:mm').format(model.workScheduleStartDate)} น. - ${DateFormat('HH:mm').format(model.workScheduleEndDate)} น.",
                            style: TextStyles.bodySm.subTitleColor.bold
                                .copyWith(fontSize: 16.0),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.home,
                            size: 15,
                            color: Colors.orangeAccent,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            " ${model.location.locationName}",
                            style: TextStyles.bodySm.subTitleColor.bold
                                .copyWith(fontSize: 16.0),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "สถานะ : ",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            model.booking.bookingStatus == 0
                                ? "รอยืนยัน"
                                : model.booking.bookingStatus == 1
                                    ? "ยืนยัน"
                                    : model.booking.bookingStatus == 2
                                        ? "ยกเลิก"
                                        : model.booking.bookingStatus == 3
                                            ? "กำลังเดินทาง"
                                            : model.booking.bookingStatus == 4
                                                ? "ถึงเป้าหมาย"
                                                : model.booking.bookingStatus == 5 ?"สำเร็จ" :"",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: model.booking.bookingStatus == 0
                                  ? const Color.fromARGB(255, 48, 71, 90)
                                  : model.booking.bookingStatus == 1
                                      ? Colors.green[400]
                                      : model.booking.bookingStatus == 2
                                          ? Colors.red[400]
                                          : model.booking.bookingStatus == 3
                                              ? Colors.yellow[700]
                                              : model.booking.bookingStatus == 4
                                                  ? Colors.orange[400]
                                                  : model.booking.bookingStatus == 5 ? Colors.green:Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    ).ripple(
      () async {
        if (model.booking.bookingStatus == 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      BarBerBookingDetailScreen(model: model)));
        } else if (model.booking.bookingStatus == 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BarBerFareBookingScreen(model: model)));
        } else if (model.booking.bookingStatus == 3) {
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
          } else {
            Position position = await Geolocator.getCurrentPosition();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BarberMap(
                        id: model.booking.bookingId,
                        BarberLocation:
                            LatLng(position.latitude, position.longitude),
                        CustomerLocation: LatLng(
                            model.location.locationLatitude,
                            model.location.locationLongitude))));
          }
        } else if (model.booking.bookingStatus == 4) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      BarBerPaymentBookingScreen(model: model)));
        }
      },
      borderRadius: const BorderRadius.all(Radius.circular(20)),
    ),
  );
}
