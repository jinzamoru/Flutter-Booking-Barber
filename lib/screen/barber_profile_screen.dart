import 'package:finalprojectbarber/model/barber_model.dart';
import 'package:finalprojectbarber/screen/barber_edit_profile_screen.dart';
import 'package:finalprojectbarber/select.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data_manager/data_manager.dart';

import '../theme/light_color.dart';
import '../widgets/logout.dart';
import 'barber_location_details_screen.dart';
import 'certificate_screen.dart';

class BarberProfileScreen extends StatelessWidget {
  const BarberProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Consumer<DataManagerProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 255, 167, 38),
                        Color.fromARGB(255, 255, 243, 224),
                      ],
                    ),
                  ),
                  child: SingleChildScrollView( 
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          "${provider.barberProfile.barberFirstName} ${provider.barberProfile.barberLastName}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "ช่างตัดผม",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 5),
                                color: Colors.deepOrange.withOpacity(.2),
                                spreadRadius: 2,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 5.0),
                              ListTile(
                                title: const Text('ชื่อ'),
                                subtitle: Text(
                                    "${provider.barberProfile.barberFirstName} ${provider.barberProfile.barberLastName}"),
                                leading: const Icon(Icons.person),
                                tileColor: Colors.white,
                              ),
                              const Divider(
                                thickness: .3,
                                color: LightColor.grey,
                              ),
                              ListTile(
                                title: const Text('บัตรประชาชน'),
                                subtitle:
                                    Text(provider.barberProfile.barberIDCard),
                                leading: const Icon(Icons.credit_card),
                                tileColor: Colors.white,
                              ),
                              const Divider(
                                thickness: .3,
                                color: LightColor.grey,
                              ),
                              ListTile(
                                title: const Text('เบอร์โทรศัพท์'),
                                subtitle:
                                    Text(provider.barberProfile.barberPhone),
                                leading: const Icon(Icons.phone_android),
                                tileColor: Colors.white,
                              ),
                              const Divider(
                                thickness: .3,
                                color: LightColor.grey,
                              ),
                              ListTile(
                                title: const Text('อีเมล'),
                                subtitle:
                                    Text(provider.barberProfile.barberEmail),
                                leading: const Icon(Icons.mail),
                                tileColor: Colors.white,
                              ),
                              const Divider(
                                thickness: .3,
                                color: LightColor.grey,
                              ),
                              ListTile(
                                title: const Text('ที่อยู่ของร้าน'),                              
                                leading: const Icon(Icons.home),
                                onTap: () {
                                  final model = BarberInfo(
                                    barberId: provider.barberProfile.barberId,
                                    barberFirstName:
                                        provider.barberProfile.barberFirstName,
                                    barberLastName:
                                        provider.barberProfile.barberLastName,
                                    barberPhone:
                                        provider.barberProfile.barberPhone,
                                    barberEmail:
                                        provider.barberProfile.barberEmail,
                                    barberPassword: "",
                                    barberIDCard:
                                        provider.barberProfile.barberIDCard,
                                    barberNamelocation:
                                        provider.barberProfile.barberNamelocation,
                                    barberLatitude:
                                        provider.barberProfile.barberLatitude,
                                    barberLongitude:
                                        provider.barberProfile.barberLongitude,
                                  );
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          BaberLocationDetailScreen(
                                        model: model,
                                      ),
                                    ),
                                  );
                                },
                                trailing: const Icon(Icons.arrow_forward,
                                    color: Colors.grey),
                                tileColor: Colors.white,
                              ),
                                const Divider(
                                thickness: .3,
                                color: LightColor.grey,
                              ),
                               ListTile(
                                title: const Text('ใบรับรอง'),                             
                                leading: const Icon(Icons.card_membership),
                                onTap: () {                              
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                         CertificatePage(id: provider.barberProfile
                                         .barberId, ),
                                    ),
                                  );
                                },
                                trailing: const Icon(Icons.arrow_forward,
                                    color: Colors.grey),
                                tileColor: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        MaterialButton(
                          onPressed: () {
                            final barberModel = BarberInfo(
                              barberId: provider.barberProfile.barberId,
                              barberFirstName:
                                  provider.barberProfile.barberFirstName,
                              barberLastName:
                                  provider.barberProfile.barberLastName,
                              barberPhone: provider.barberProfile.barberPhone,
                              barberEmail: provider.barberProfile.barberEmail,
                              barberPassword: "",
                              barberIDCard: provider.barberProfile.barberIDCard,
                              barberNamelocation:
                                  provider.barberProfile.barberNamelocation,
                              barberLatitude:
                                  provider.barberProfile.barberLatitude,
                              barberLongitude:
                                  provider.barberProfile.barberLongitude,
                            );
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    BarberEditProfileScreen(model: barberModel),
                              ),
                            );
                          },
                          color: Colors.orange,
                          child: const Text(
                            'แก้ไขโปรไฟล์',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Logout().accountLogout().whenComplete(() {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => SelectPage()),
                                  (Route<dynamic> route) => false);
                            });
                          },
                          color: Colors.orange,
                          child: const Text(
                            'ออกจากระบบ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
