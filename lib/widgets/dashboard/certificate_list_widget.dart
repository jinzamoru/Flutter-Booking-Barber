
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/barber_model.dart';
import '../certificate_tile.dart';

// ignore: non_constant_identifier_names
Widget CertificateList(List<certificateModel> certificate, BuildContext context) {
  return SliverGrid(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
    ),
    delegate: SliverChildBuilderDelegate(
      (context, index) {
        return getCertificateWidgetList(certificate, index, context);
      },
      childCount: certificate.length,
    ),
  );
}

Widget getCertificateWidgetList(
    List<certificateModel> certificateDataList, int index, BuildContext context) {
  return Container(
    child: certificateTile(certificateDataList[index], index, context),
  );
}
