// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names

import 'package:finalprojectbarber/php_data/php_data.dart';
import 'package:finalprojectbarber/theme/extention.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data_manager/data_manager.dart';
import '../model/customer_model.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';
import 'location_add_details_screen.dart';
import 'location_details_screen.dart';

class PickLocationPage extends StatefulWidget {
  const PickLocationPage({
    super.key,
  });

  @override
  _PickLocationPageState createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getAllLocation(context);
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
                          height: 40.0,
                        ),
                        const BackButton(
                          color: Colors.black,
                        ),
                        Text(
                          "เลือกที่อยู่",
                          style: TextStyles.titleM,
                        ),
                      ],
                    ).p16,
                  ],
                ),
              ),
              PickLocationList(providerData.getAllLocation, context),
            ],
          );
        },
      ),
    );
  }
}

Widget PickLocationList(List<LocationInfo> location, BuildContext context) {
  return SliverList(
    delegate: SliverChildListDelegate(
      [
        getPickLocationWidgetList(location, context),
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

Widget getPickLocationWidgetList(
    List<LocationInfo> locationDataList, BuildContext context) {
  return Column(
      children: locationDataList.map((x) {
    return PickLocationTile(x, context);
  }).toList());
}

Widget PickLocationTile(LocationInfo model, BuildContext context) {
  return Container(
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
              onTap: () {
                Navigator.pop(context, model);
              },
              contentPadding: const EdgeInsets.all(0),
              title: Text(
                model.locationName,
                style: TextStyles.titleM.bold
                    .copyWith(color: Colors.black, fontSize: 18.0),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(24),
            ),
            child: IconButton(
              icon: Icon(
                Icons.edit_square,
                size: 25,
                color: Colors.blue.shade400,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => LocationDetailScreen(model: model),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            width: 5.0,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(24),
            ),
            child: IconButton(
              icon: Icon(
                Icons.delete,
                size: 25,
                color: Colors.red.shade400,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('ลบข้อมูล'),
                      content: const Text('ต้องการลบข้อมูลนี้หรือไม่?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('ยกเลิก'),
                        ),
                        TextButton(
                          onPressed: () {
                            deleteLocation(model.locationId, context);
                          },
                          child: const Text('ลบ'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
