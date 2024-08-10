import 'package:finalprojectbarber/screen/customer_profile_screen.dart';
import 'package:finalprojectbarber/screen/customer_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data_manager/data_manager.dart';
import 'screen/customer_booking_screen.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  int _selectedIndex = 0;
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String id = Provider.of<DataManagerProvider>(context, listen: false)
        .customerProfile
        .customerId;
    final List<Widget> pages = [
      const CustomerHome(),
      CustomerBookingPage(id: id),
      // PlaceAutocompleteWidget(),
      const CustomerProfileScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 255, 255,
            255), // Set the background color of the BottomNavigationBar
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(
            255, 253, 168, 94), // Set the color when item is selected
        unselectedItemColor: const Color.fromARGB(
            255, 197, 197, 197), // Set the color for unselected items
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'หน้าแรก'),
          BottomNavigationBarItem(
              icon: Icon(Icons.query_builder), label: 'การจองคิว'),
          // BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person_pin), label: 'บัญชี'),
        ],
      ),
    );
  }
}
