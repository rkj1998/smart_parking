import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:smart_parking/const.dart';

class Recents extends StatefulWidget {
  @override
  State createState() => _RecentsState();
}

class _RecentsState extends State<Recents> {
  List<dynamic> nearbyParkingList = [];

  @override
  void initState() {
    super.initState();
    _fetchNearbyParking();
  }

  Future<void> _fetchNearbyParking() async {
    await _requestLocationPermission(); // Request location permission
    Position position = await _getCurrentLocation();
    if (kDebugMode) {
      print(position);
    }

    const String placesEndpoint =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    final String location =
        '${position.latitude},${position.longitude}';
    const String radius = '1000'; // Radius in meters, adjust as needed
    const String type = 'parking';
    const String keyword = 'parking';

    final String request =
        '$placesEndpoint?location=$location&radius=$radius&type=$type&keyword=$keyword&key=$apiKey';

    final http.Response response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      setState(() {
        nearbyParkingList = data['results'];
      });
    } else {
      throw Exception('Failed to load nearby parking');
    }
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, throw an error or handle it accordingly
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse) {
      // Permission not granted, throw an error or handle it accordingly
      throw Exception('Location permission is not granted.');
    }
  }

  Future<Position> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: nearbyParkingList.length,
        itemBuilder: (context, index) {
          final parking = nearbyParkingList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: Colors.grey[900],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      parking['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      parking['vicinity'],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
