// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;

class MapView extends StatelessWidget {
  final Map<String, double>? initialPosition;

  MapView({super.key, this.initialPosition});
  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map View')),
      body: Center(
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            backgroundColor: Colors.black, // optional
            initialCenter: latLng.LatLng(
              initialPosition != null
                  ? initialPosition!['latitude'] ?? 0.0
                  : 24.4539,
              initialPosition != null
                  ? initialPosition!['longitude'] ?? 0.0
                  : 54.3773,
            ),
            interactionOptions: const InteractionOptions(),

            initialZoom: 14,
          ),
          children: [
            // The TileLayer widget is used to display the map tiles.
            // It uses a URL template to fetch the map tiles from a tile server.
            TileLayer(
              urlTemplate:
                  // 'https://{s}.basemaps.cartocdn.com/dark_matter/{z}/{x}/{y}{r}.png',
                  'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
              subdomains: const ['a', 'b', 'c', 'd'],
              userAgentPackageName: 'com.example.app',
              retinaMode: true,
            ),
            // The MarkerLayer widget is used to display markers on the map.
            // It uses the latLng.LatLng class to set the position of the marker.
            if (initialPosition != null)
              MarkerLayer(
                markers: [
                  // The Marker widget is used to display a marker on the map.
                  // It uses the latLng.LatLng class to set the position of the marker.
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: latLng.LatLng(
                      initialPosition!['latitude'] ?? 0.0,
                      initialPosition!['longitude'] ?? 0.0,
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                    // The child of the Marker widget is an Image widget that displays the marker icon.
                    // The image is loaded from the assets using the Image.asset method.
                    // child: Image.asset(
                    //   Resources.mapMarker,
                    //   fit: BoxFit.contain,
                    //   height: 60,
                    //   width: 60,
                    // ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
