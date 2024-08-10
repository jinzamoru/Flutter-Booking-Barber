import 'package:finalprojectbarber/model/hair_model.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:finalprojectbarber/widgets/random_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../php_data/php_data.dart';
import '../screen/hair_details_screen.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';

Widget hairTile(HairModel model, BuildContext context) {
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
              leading: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(13)),
                child: Hero(
                  tag: 'image',
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: randomColor(context),
                    ),
                    child: Image.network(
                      "$server/hair/${model.hairPhoto}",
                      loadingBuilder: (context, child, loading) {
                        if (loading == null) {
                          return child;
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.cyan,
                            ),
                          );
                        }
                      },
                      height: 50,
                      width: 50,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.all(0),
              title: Text(
                model.hairName,
                style: TextStyles.title.bold
                    .copyWith(color: Colors.black, fontSize: 16.0),
              ),
              subtitle: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.monetization_on_outlined,
                            size: 15,
                            color: Colors.black45,
                          ),
                          const SizedBox(width: 3.0),
                          Text(
                            "${model.hairPrice} บาท",
                            style: TextStyles.bodySm.subTitleColor.bold
                                .copyWith(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
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
                    builder: (context) => HairDetailScreen(model: model),
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
                            deleteHair(model.hairId, model.barberId, context);
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
