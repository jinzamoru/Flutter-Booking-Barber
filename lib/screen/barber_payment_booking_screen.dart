// ignore_for_file: use_build_context_synchronously

import 'package:finalprojectbarber/model/booking_model.dart';
import 'package:finalprojectbarber/screen/barber_qrcode_payment_screen.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/light_color.dart';
import '../theme/text_styles.dart';
import '../theme/theme.dart';
import 'barber_cash_payment_screen.dart';

class BarBerPaymentBookingScreen extends StatefulWidget {
  final BarberBookingModel model;

  const BarBerPaymentBookingScreen({
    super.key,
    required this.model,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BarBerPaymentBookingScreenState createState() =>
      _BarBerPaymentBookingScreenState();
}

class _BarBerPaymentBookingScreenState
    extends State<BarBerPaymentBookingScreen> {
  late BarberBookingModel model;
  String _paymentMethod = '';

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
                                Text(
                                  "สถานะ : ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey[600],
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
                          Text("เลือกวิธีรับเงิน", style: titleStyle).vP16,
                          Column(
                            children: <Widget>[
                              ListTile(
                                onTap: () {
                                  setState(() {
                                    _paymentMethod = 'cash';
                                  });
                                },
                                leading: const Icon(
                                  Icons.attach_money_outlined,
                                  color: Colors.orangeAccent,
                                ),
                                title: const Text('เงินสด'),
                                trailing: Radio(
                                  value: 'cash',
                                  groupValue: _paymentMethod,
                                  onChanged: (value) {
                                    setState(() {
                                      _paymentMethod = value.toString();
                                    });
                                  },
                                  activeColor: Colors.orangeAccent,
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  setState(() {
                                    _paymentMethod = 'qrCode';
                                  });
                                },
                                leading: const Icon(
                                  Icons.qr_code_scanner,
                                  color: Colors.orangeAccent,
                                ),
                                title: const Text('QR Code'),
                                trailing: Radio(
                                  value: 'qrCode',
                                  groupValue: _paymentMethod,
                                  onChanged: (value) {
                                    setState(() {
                                      _paymentMethod = value.toString();
                                    });
                                  },
                                  activeColor: Colors.orangeAccent,
                                ),
                              ),
                            ],
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
                                  if (_paymentMethod == "qrCode") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BarBerQRCodeScreen(
                                                    model: model)));
                                  } else if (_paymentMethod == "cash") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BarBerCashScreen(
                                                    model: model)));
                                  }
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
                                () {},
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
