// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names

import 'dart:convert';
import 'package:finalprojectbarber/key/api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../components/k_components.dart';
import '../model/customer_model.dart';
import 'customer_google_map.dart';

class CustomerPlaceAutocompleteWidget extends StatefulWidget {
  final LocationInfo cuslocation;

  const CustomerPlaceAutocompleteWidget({super.key, required this.cuslocation});

  @override
  _CustomerPlaceAutocompleteWidgetState createState() =>
      _CustomerPlaceAutocompleteWidgetState();
}

class _CustomerPlaceAutocompleteWidgetState
    extends State<CustomerPlaceAutocompleteWidget> {
  final TextEditingController _controller = TextEditingController();
  late LocationInfo model;
  late double selectedLatitude;
  late double selectedLongitude;

  @override
  void initState() {
    model = widget.cuslocation;
    super.initState();
    _controller.text = model.locationName;
    selectedLatitude = model.locationLatitude;
    selectedLongitude = model.locationLongitude;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขที่อยู่'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              keyboardType: TextInputType.emailAddress,
              cursorColor: Colors.orangeAccent,
              style: const TextStyle(fontSize: 18.0),
              decoration: kTextFormFieldDecoration.copyWith(
                labelText: 'ค้นหาที่อยู่',
              ),
              onChanged: (value) {
                // Call the Places API for autocomplete suggestions
                _fetchAddressSuggestions(value);
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(suggestions[index]),
                    leading: const Icon(Icons.pin_drop),
                    onTap: () async {
                      final coordinates =
                          await _fetchPlaceCoordinates(place_id[index]);
                      setState(() {
                        selectedLatitude = coordinates['latitude']!;
                        selectedLongitude = coordinates['longitude']!;
                        _controller.text = suggestions[index];
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 15.0),
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          onPressed: () async {
            LocationInfo locationInfo = LocationInfo(
                locationCusId: model.locationCusId,
                locationId: model.locationId,
                locationName: _controller.text,
                locationLatitude: selectedLatitude,
                locationLongitude: selectedLongitude);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomerMap(
                          cuslocation: locationInfo,
                        )));
          },
          color: Colors.orangeAccent,
          textColor: Colors.black,
          child: const Text('ถัดไป', style: TextStyle(fontSize: 20.0)),
        ),
      ),
    );
  }

  List<String> suggestions = [];
  List<String> place_id = [];

  Future<List<Map<String, dynamic>>> _fetchAddressSuggestions(
      String input) async {
    final response = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&language=th&components=country:TH',
    ));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['predictions'] != null) {
        setState(() {
          suggestions = List<String>.from(jsonResponse['predictions']
              .map((item) => item['description'].toString()));
          place_id = List<String>.from(jsonResponse['predictions']
              .map((item) => item['place_id'].toString()));
        });
      }
    }
    throw Exception('Failed to load suggestions');
  }

  Future<Map<String, double>> _fetchPlaceCoordinates(String placeId) async {
    final response = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?place_id=$placeId&key=$apiKey',
    ));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['results'] != null &&
          jsonResponse['results'].isNotEmpty) {
        final location = jsonResponse['results'][0]['geometry']['location'];
        final latitude = location['lat'];
        final longitude = location['lng'];
        return {'latitude': latitude, 'longitude': longitude};
      }
    }
    throw Exception('Failed to fetch place coordinates');
  }
}
