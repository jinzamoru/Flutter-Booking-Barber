// ignore_for_file: library_private_types_in_public_api

import 'package:finalprojectbarber/php_data/php_data.dart';
import 'package:finalprojectbarber/widgets/dashboard/location_list_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data_manager/data_manager.dart';


class LocationPage extends StatefulWidget {
  const LocationPage({
    super.key,
  });

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getAllLocation(context);
    return Scaffold(
      appBar: AppBar(title: const Text("ที่อยู่"),),
      body: Consumer<DataManagerProvider>(
        builder: (context, providerData, child) {
          return CustomScrollView(
            slivers: <Widget>[           
              LocationList(providerData.getAllLocation, context),             
            ],
          );
        },
      ),
    );
  }
}
