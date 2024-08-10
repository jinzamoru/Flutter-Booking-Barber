// ignore_for_file: non_constant_identifier_names

import 'package:finalprojectbarber/theme/extention.dart';
import 'package:finalprojectbarber/widgets/workschedule_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/barber_model.dart';

Widget WorkScheduleList(List<AllWorkScheduleModel> model, BuildContext context) {
  return SliverList(
    delegate: SliverChildListDelegate(
      [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "ช่างตัดผม",
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
            : getworkscheluleWidgetList(model, context)
      ],
    ),
  );
}

Widget getworkscheluleWidgetList(
    List<AllWorkScheduleModel> barberDataList, BuildContext context) {
  return Column(
      children: barberDataList.map((x) {
    return workScheduleTile(x, context);
  }).toList());
}
