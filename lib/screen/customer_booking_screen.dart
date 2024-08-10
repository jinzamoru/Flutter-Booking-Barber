// ignore_for_file: library_private_types_in_public_api

import 'package:finalprojectbarber/php_data/php_data.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_manager/data_manager.dart';
import '../theme/text_styles.dart';
import '../widgets/dashboard/customer_booking_list_widget.dart';

class CustomerBookingPage extends StatefulWidget {
  final String id;

  const CustomerBookingPage({
    super.key,
    required this.id,
  });

  @override
  _CustomerBookingPageState createState() => _CustomerBookingPageState();
}

class _CustomerBookingPageState extends State<CustomerBookingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getCustomerBooking(widget.id, context);
    return Scaffold(
      body: Consumer<DataManagerProvider>(
        builder: (context, providerData, child) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          "การจองคิว",
                          style: TextStyles.titleMedium,
                        ),
                      ],
                    ).p16,
                  ],
                ),
              ),
              CustomerBookingList(providerData.getAllCustomerBooking, context),
            ],
          );
        },
      ),
    );
  }
}
