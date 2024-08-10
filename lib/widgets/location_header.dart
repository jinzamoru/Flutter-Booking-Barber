import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/material.dart';

import '../theme/text_styles.dart';

class LocationHeader extends StatelessWidget {
  const LocationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 40.0,
        ),
        const BackButton(
          color: Colors.black,
        ),
        Text(
          "ที่อยู่",
          style: TextStyles.titleM,
        ),
      ],
    ).p16;
  }
}
