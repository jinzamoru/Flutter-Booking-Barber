import 'package:finalprojectbarber/model/hair_model.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../hair_tile.dart';

Widget hairsList(List<HairModel> hair, BuildContext context) {
  return SliverList(
    delegate: SliverChildListDelegate(
      [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Text("", style: TextStyles.title.bold),
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
        gethairWidgetList(hair, context)
      ],
    ),
  );
}

Widget gethairWidgetList(
    List<HairModel> hairDataList, BuildContext context) {
  return Column(
      children: hairDataList.map((x) {
    return hairTile(x, context);
  }).toList());
}
