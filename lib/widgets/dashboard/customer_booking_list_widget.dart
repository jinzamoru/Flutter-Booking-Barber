import 'package:finalprojectbarber/model/booking_model.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../customer_booking_tile.dart';

// ignore: non_constant_identifier_names
Widget CustomerBookingList(
    List<CustomerBookingModel> model, BuildContext context) {
  return SliverList(
    delegate: SliverChildListDelegate(
      [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Text("ช่างตัดผม",style:  TextStyle(fontSize: 14 * 1.2, fontWeight: FontWeight.w300), ),
            // IconButton(
            //     icon: Icon(
            //       Icons.sort,
            //       color: Theme.of(context).primaryColor,
            //     ),
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           CupertinoPageRoute(
            //               builder: (context) => const AllBarbers()));
            //     })
            // .p(12).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(20))),
          ],
        ).hP16,
        model.isEmpty
            ? const Center(
                child: Text("ไม่มีการจอง"),
              )
            : getCustomerBookingWidgetList(model, context)
      ],
    ),
  );
}

Widget getCustomerBookingWidgetList(
    List<CustomerBookingModel> dataList, BuildContext context) {
  return Column(
      children: dataList.map((x) {
    return CustomerBookingTile(x, context);
  }).toList());
}
