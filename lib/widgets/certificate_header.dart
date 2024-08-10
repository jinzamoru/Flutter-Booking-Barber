import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/material.dart';

import '../theme/text_styles.dart';

class CertificateHeader extends StatelessWidget {
  const CertificateHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          height: 40.0,
        ),
        Text(
          "รูปใบรอง",
          style: TextStyles.titleM,
        ),
      ],
    ).p16;
  }
}
