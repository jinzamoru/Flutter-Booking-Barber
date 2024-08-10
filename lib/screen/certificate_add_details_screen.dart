// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'dart:io';

import 'package:finalprojectbarber/php_data/php_data.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/barber_model.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';
import '../theme/theme.dart';

class CertificateAddDetailScreen extends StatefulWidget {
  final String id;

  const CertificateAddDetailScreen({super.key, required this.id});

  @override
  _CertificateAddDetailScreenState createState() =>
      _CertificateAddDetailScreenState();
}

class _CertificateAddDetailScreenState
    extends State<CertificateAddDetailScreen> {
  List<File> _imageFiles = [];
  late String barberId = "";

  @override
  void initState() {
    super.initState();
    barberId = widget.id;
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    setState(() {
      _imageFiles =
          pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyles.title.copyWith(fontSize: 25).bold;
    if (AppTheme.fullWidth(context) < 393) {
      titleStyle = TextStyles.title.copyWith(fontSize: 23).bold;
    }
    return Scaffold(
      backgroundColor: LightColor.extraLightBlue,
      body: Stack(
        children: <Widget>[
          DraggableScrollableSheet(
            maxChildSize: 1.0,
            minChildSize: 1.0,
            initialChildSize: 1.0,
            builder: (context, scrollController) {
              return Container(
                height: AppTheme.fullHeight(context) * .5,
                padding: const EdgeInsets.only(
                  left: 19,
                  right: 19,
                  top: 16,
                ), //symmetric(horizontal: 19, vertical: 16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const BackButton(
                                color: Colors.black,
                              ),
                              Expanded(
                                child: Text(
                                  "เพิ่มรูป",
                                  style:
                                      titleStyle.copyWith(color: Colors.black),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: .3,
                          color: LightColor.grey,
                        ),
                        Container(
                          height: 45,
                          alignment: Alignment.centerLeft,
                          child: const Text("รูปใบรับรอง"),
                        ),
                        InkResponse(
                          onTap: pickImages,
                          child: Container(
                            height: 250,
                            width: double.infinity,
                            decoration: ShapeDecoration(
                              color: Colors.grey[300],
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                            ),
                            child: _imageFiles.isEmpty
                                ? const Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo_outlined,
                                          color: Colors.black),
                                      SizedBox(width: 8),
                                      Text('เลือกรูปใบรับรอง',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ],
                                  )
                                : GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 4.0,
                                      mainAxisSpacing: 4.0,
                                    ),
                                    itemCount: _imageFiles.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Image.file(
                                        _imageFiles[index],
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        MaterialButton(
                          elevation: 10.0,
                          onPressed: () async {
                            if (_imageFiles.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('ข้อผิดพลาด'),
                                    content:
                                        const Text("กรุณาเลือกรูปใบรับรอง"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('ตกลง'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              final model = certificateModel(
                                certificatesId: "",
                                certificatesPhoto: "",
                                certificatesBarberID: barberId,
                              );
                              try {
                                if (await addCertificate(
                                    model, _imageFiles, context)) {
                                  setState(() {
                                    _imageFiles = [];
                                  });
                                }
                              } catch (e) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('แจ้งเตือน'),
                                      content: const Text(
                                          "เกิดข้อผิดพลาดในการอัพโหลดรูปภาพ"),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('ตกลง'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          },
                          minWidth: double.infinity,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          color: const Color.fromARGB(255, 255, 183, 77),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Text(
                              'อัพโหลด',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20.0,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ).vP16),
              );
            },
          ),
        ],
      ),
    );
  }
}
