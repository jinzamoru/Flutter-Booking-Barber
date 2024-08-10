import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_manager/data_manager.dart';
import '../theme/text_styles.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 30.0,
        ),
        Text(
          "สวัสดี ,คุณ ${Provider.of<DataManagerProvider>(context).getCustomerProfile.customerFirstName}",
          style: TextStyles.titleMedium,
        ),
      ],
    ).p16;
  }
}
