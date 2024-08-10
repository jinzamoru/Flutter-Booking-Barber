import 'package:finalprojectbarber/login.dart';
import 'package:finalprojectbarber/login2.dart';
import 'package:flutter/material.dart';

class SelectPage extends StatelessWidget {
  const SelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {         
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()), // OtherPage คือหน้าอื่นที่คุณต้องการเด้งไป
                );
              },
              child: Card(
                elevation: 5.0,
                child: Image.asset(
                  'assets/11.png', // เส้นทางไปยังรูปภาพใน assets
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                // เมื่อคลิกที่รูป ให้เปลี่ยนไปยังหน้าอื่น
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage2()), // OtherPage คือหน้าอื่นที่คุณต้องการเด้งไป
                );
              },
              child: Card(
                elevation: 5.0,
                child: Image.asset(
                  'assets/22.png', // เส้นทางไปยังรูปภาพใน assets
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}