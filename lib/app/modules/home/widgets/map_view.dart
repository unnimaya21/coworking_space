// ignore_for_file: must_be_immutable

import 'package:coworking_space_app/app/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as latLng;

class MapView extends StatelessWidget {
  MapView({super.key});
  MapController mapController = MapController();
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final markers =
        homeController.allBranches.map<Marker>((branch) {
          final p = _toLatLng(branch.coordinates); // robust parsing
          return Marker(
            point: p,
            width: 80,
            height: 80,
            child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
          );
        }).toList();
    final initialCenter =
        markers.isNotEmpty ? markers.first.point : const latLng.LatLng(0, 0);
    if (markers.length > 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final bounds = LatLngBounds.fromPoints(
          markers.map((m) => m.point).toList(),
        );
        mapController.fitCamera(
          CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(40)),
        );
      });
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Our Branches'), centerTitle: false),
      body: Center(
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: initialCenter,
            initialZoom: 14,
            interactionOptions: const InteractionOptions(),
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
              userAgentPackageName: 'com.example.app',
              subdomains: const ['a', 'b', 'c', 'd'],
            ),
            MarkerLayer(markers: markers),
          ],
        ),
      ),
    );
  }

  latLng.LatLng _toLatLng(Map<String, dynamic> location) {
    double _toDouble(dynamic v) {
      if (v is num) return v.toDouble();
      if (v is String) {
        final t = v.trim();
        if (t.isEmpty) return 0.0;
        return double.tryParse(t) ?? 0.0;
      }
      return 0.0;
    }

    final lat = _toDouble(location['latitude']);
    final lng = _toDouble(location['longitude']);
    return latLng.LatLng(lat, lng);
  }
}
