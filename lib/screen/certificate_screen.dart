// certificate_page.dart

// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:finalprojectbarber/php_data/php_data.dart';
import 'package:finalprojectbarber/screen/certificate_add_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data_manager/data_manager.dart';
import '../widgets/dashboard/certificate_list_widget.dart';

class CertificatePage extends StatefulWidget {
  final String id;
  const CertificatePage({
    super.key,
    required this.id,
  });

  @override
  _CertificatePageState createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  late String id = "";
  @override
  void initState() {
    super.initState();
    id = widget.id;
    getCertificates(id, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ใบรับรอง"),),
      body: Consumer<DataManagerProvider>(
        builder: (context, providerData, child) {
          return CustomScrollView(
            slivers: <Widget>[           
              CertificateList(providerData.getAllCertificate, context),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => CertificateAddDetailScreen(
                    id: Provider.of<DataManagerProvider>(context, listen: false)
                        .barberProfile
                        .barberId)),
          );
          getCertificates(id, context);
        },
        backgroundColor: Colors.orange[300],
        child: const Icon(Icons.add),
      ),
    );
  }
}
