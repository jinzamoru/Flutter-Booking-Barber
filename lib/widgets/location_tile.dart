import 'package:finalprojectbarber/model/customer_model.dart';
import 'package:finalprojectbarber/php_data/php_data.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screen/location_details_screen.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';

Widget locationTile(LocationInfo model, BuildContext context) {
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
