import 'package:finalprojectbarber/theme/extention.dart';
import 'package:finalprojectbarber/widgets/barber_workschedule_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/barber_model.dart';

Widget barberWorkScheduleList(List<WorkScheduleModel> model, BuildContext context) {
  return SliverList(
    delegate: SliverChildListDelegate(
      [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "เวลา",
              style: TextStyle(fontSize: 14 * 1.2, fontWeight: FontWeight.w300),
            ),
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
                child: Text(
                "ไม่มีการลงงาน",
                style: TextStyle(fontSize: 18 * 1.2),
              ))
            : getBarberWorkScheduleWidgetList(model, context)
      ],
    ),
  );
}

Widget getBarberWorkScheduleWidgetList(
    List<WorkScheduleModel> barberDataList, BuildContext context) {
  return Column(
      children: barberDataList.map((x) {
    return barberWorkScheduleTile(x, context);
  }).toList());
}
