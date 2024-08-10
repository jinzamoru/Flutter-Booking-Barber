import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../model/barber_model.dart';
import '../php_data/php_data.dart';
import '../screen/photo_view_page.dart';

Widget certificateTile(
    certificateModel model, int index, BuildContext context) {
  return Stack(
    children: [
      InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PhotoViewPage(
              index: index,
              photos: [model.certificatesPhoto],
            ),
          ),
        ),
        child: Hero(
          tag: model.certificatesPhoto,
          child: CachedNetworkImage(
            imageUrl: "$server/certificate/${model.certificatesPhoto}",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            placeholder: (context, url) => Container(
              color: Colors.grey,
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.red.shade400,
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 5,
        right: 5,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(24),
          ),
          child: IconButton(
            icon: Icon(
              Icons.delete,
              size: 16,
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
                          deleteCertificate(model.certificatesBarberID,
                              model.certificatesId, model.certificatesPhoto, context);
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
      ),
    ],
  );
}
