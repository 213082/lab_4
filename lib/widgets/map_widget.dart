import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../google_maps.dart';
import '../models/location.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  Location university = Location("FINKI", 42.0040989, 21.409744464957683);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Map',
        style: TextStyle(
          color: Colors.white,
        ),),
        backgroundColor: Colors.teal, // AppBar color for a clean look
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(41.9981, 21.4254),
          initialZoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'mk.ukim.finki.mis',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(
                  university.latitude,
                  university.longitude,
                ),
                width: 100,
                height: 100,
                child: GestureDetector(
                  onTap: () {
                    _showAlertDialog(); // Show the alert dialog when tapped
                  },
                  child: const Icon(
                    Icons.pin_drop,
                    color: Colors.red, // Pin color changed for visibility
                    size: 40,
                  ),
                ),
              )
            ],
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Function to show the alert dialog
  Future<void> _showAlertDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Open Google Maps?'),
          content: const Text('Do you want to open Google Maps for routing?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                GoogleMaps.openGoogleMaps(
                  university.latitude,
                  university.longitude,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Open'),
            ),
          ],
        );
      },
    );
  }
}
