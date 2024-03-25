import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package
import 'package:smart_parking/const.dart';


class Search extends StatefulWidget {
  final String searchTerm;
  const Search({super.key,required this.searchTerm});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<dynamic> nearbyParkingList = [];

  @override
  void initState() {
    super.initState();
    _fetchNearbyParking(widget.searchTerm);
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
  Future<void> _fetchNearbyParking(String searchTerm) async {
    await _requestLocationPermission(); // Request location permission
    Position position = await _getCurrentLocation();
    final String location =
        '${position.latitude},${position.longitude}';
    print("HERE");
    print(searchTerm);
    const String placesEndpoint =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    const String radius = '1000'; // Radius in meters, adjust as needed
    // Remove keyword parameter or adjust for a more specific search term
    // const String type = 'parking';
    final String request =
        '$placesEndpoint?location=$location&radius=$radius&type=parking&key=$apiKey';

    print(request);
    final http.Response response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      print(response.body);
      // The response contains information about parking locations, not availability
      setState(() {
        nearbyParkingList = data['results'];
      });
    } else {
      throw Exception('Failed to load nearby parking');
    }
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
            child: InkWell(
              onTap: () {
                launchMap(parking); // Launch maps when clicked
              },
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
            ),
          );
        },
      ),
    );
  }

  Future<void> launchMap(dynamic parking) async {
    // Extract latitude and longitude from the parking location data
    final double latitude = parking['geometry']['location']['lat'];
    final double longitude = parking['geometry']['location']['lng'];

    // Create the URL with the latitude and longitude
    final String url = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

    // Launch the URL
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}


