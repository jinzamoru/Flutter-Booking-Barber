import 'package:finalprojectbarber/model/customer_model.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:finalprojectbarber/widgets/location_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data_manager/data_manager.dart';
import '../../screen/location_add_details_screen.dart';
import '../../theme/light_color.dart';
import '../../theme/text_styles.dart';

// ignore: non_constant_identifier_names
Widget LocationList(List<LocationInfo> location, BuildContext context) {
  return SliverList(
    delegate: SliverChildListDelegate(
      [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[       
          ],
        ).hP16,
        getLocationWidgetList(location, context),
        Container(
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
                    contentPadding: const EdgeInsets.all(0),
                    onTap: () async {
                     
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => LocationAddDetailScreen(
                                    id: Provider.of<DataManagerProvider>(
                                            context,
                                            listen: false)
                                        .customerProfile
                                        .customerId
                                  )),
                        );
                      
                    },
                    title: Text(
                      "เพิ่มที่อยู่",
                      style: TextStyles.titleM.bold
                          .copyWith(color: Colors.black, fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}

Widget getLocationWidgetList(
    List<LocationInfo> locationDataList, BuildContext context) {
  return Column(
      children: locationDataList.map((x) {
    return locationTile(x, context);
  }).toList());
}
