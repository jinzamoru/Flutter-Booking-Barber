// ignore_for_file: use_build_context_synchronously

import 'package:finalprojectbarber/model/booking_model.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';
import '../theme/theme.dart';

class CustomerFareBookingScreen extends StatefulWidget {
  final CustomerBookingModel model;

  const CustomerFareBookingScreen({
    super.key,
    required this.model,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomerFareBookingScreenState createState() =>
      _CustomerFareBookingScreenState();
}

class _CustomerFareBookingScreenState extends State<CustomerFareBookingScreen> {
  late CustomerBookingModel model;

  @override
  void initState() {
    model = widget.model;
    super.initState();
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
                                    model.booking.bookingStatus == 3
                                        ? "กำลังเดินทาง"
                                        : "ถึงเป้าหมายแล้ว",
                                    style: titleStyle.copyWith(
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.assignment_ind,
                                size: 30.0,
                                color: Colors.orangeAccent,
                              ), // Replace with your desired icon
                              const SizedBox(
                                  width:
                                      3.0), // Add spacing between icon and line
                              Container(
                                width: 100,
                                height: 3,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  color: Colors.orangeAccent,
                                ),
                              ),
                              const SizedBox(width: 3.0),
                              const Icon(
                                Icons.motorcycle_rounded,
                                size: 30.0,
                                color: Colors.orangeAccent,
                              ), // Replace with your desired icon
                              const SizedBox(width: 3.0),
                              Container(
                                width: 100,
                                height: 3,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  color: Colors.orangeAccent,
                                ),
                              ),
                              Icon(
                                Icons.pin_drop,
                                size: 30.0,
                                color: model.booking.bookingStatus == 3
                                    ? Colors.grey
                                    : Colors.orangeAccent,
                              ), //
                            ],
                          ),
                          const Divider(
                            thickness: .3,
                            color: LightColor.grey,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                " ${model.barber.barberFirstName} ${model.barber.barberLastName}",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 20.0),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Colors.orange[100],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.phone,
                                    color: Colors.orange,
                                  ),
                                ),
                              ).ripple(
                                () async {
                                  final phoneNumber = model.barber.barberPhone;
                                  final uri = Uri.parse('tel:$phoneNumber');

                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri);
                                  } else {
                                    throw 'Could not launch $uri';
                                  }
                                },
                                borderRadius: BorderRadius.circular(10),
                              ).vP8,
                            ],
                          ),
                          const Divider(
                            thickness: .3,
                            color: LightColor.grey,
                          ),
                          Text("ข้อมูล", style: titleStyle).vP4,
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
                                  " ${model.barber.barberPhone}",
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
