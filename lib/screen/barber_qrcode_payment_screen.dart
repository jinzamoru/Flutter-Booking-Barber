// ignore_for_file: use_build_context_synchronously

import 'package:finalprojectbarber/model/booking_model.dart';
import 'package:finalprojectbarber/php_data/php_data.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_manager/data_manager.dart';
import '../model/payment_model.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';
import '../theme/theme.dart';

class BarBerQRCodeScreen extends StatefulWidget {
  final BarberBookingModel model;

  const BarBerQRCodeScreen({
    super.key,
    required this.model,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BarBerQRCodeScreenState createState() => _BarBerQRCodeScreenState();
}

class _BarBerQRCodeScreenState extends State<BarBerQRCodeScreen> {
  late BarberBookingModel model;

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String phone = Provider.of<DataManagerProvider>(context, listen: false)
        .barberProfile
        .barberPhone;
    String name = Provider.of<DataManagerProvider>(context, listen: false)
        .barberProfile
        .barberFirstName;
    String lastname = Provider.of<DataManagerProvider>(context, listen: false)
        .barberProfile
        .barberLastName;
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
                          Center(
                            child: Image.network(
                              "https://promptpay.io/$phone/${model.booking.bookingPrice}.png",
                              width: 350.0,
                              height: 350.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Center(
                            child: Text(
                              "$name $lastname",
                              style: titleStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Center(
                            child: Text(
                              "ราคา ${model.booking.bookingPrice} บาท",
                              style: titleStyle,
                              textAlign: TextAlign.center,
                            ),
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
