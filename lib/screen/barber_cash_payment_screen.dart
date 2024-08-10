// ignore_for_file: use_build_context_synchronously

import 'package:finalprojectbarber/model/booking_model.dart';
import 'package:finalprojectbarber/php_data/php_data.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/payment_model.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';
import '../theme/theme.dart';

class BarBerCashScreen extends StatefulWidget {
  final BarberBookingModel model;

  const BarBerCashScreen({
    super.key,
    required this.model,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BarBerCashScreenState createState() => _BarBerCashScreenState();
}

class _BarBerCashScreenState extends State<BarBerCashScreen> {
  late BarberBookingModel model;

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
                                    "${model.customer.customerFirstName} ${model.customer.customerLastName}",
                                    style: titleStyle.copyWith(
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                const Text(
                                  "สถานะ : ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "รอชำระเงิน",
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
                          Text("ตรวจสอบข้อมูล", style: titleStyle).vP16,
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
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18.0),
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
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18.0),
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
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18.0),
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
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 20.0),
                                ),
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
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 15.0),
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          onPressed: () async {
            final PaymentModel paymentModel = PaymentModel(
                paymentId: '',
                paymentAmount: model.booking.bookingPrice,
                bookingId: model.booking.bookingId,
                paymentTime: DateTime.now(),
                paymentStatus: 0);
            await addPayment(
                model.booking.workScheduleId, paymentModel, context);
          },
          color: Colors.green,
          textColor: Colors.white,
          child:
              const Text('ยืนยันการชำระเงิน', style: TextStyle(fontSize: 18.0)),
        ),
      ),
    );
  }
}
