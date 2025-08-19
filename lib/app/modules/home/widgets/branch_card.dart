import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import Get for navigation
import 'package:coworking_space_app/app/domain/entities/branches.dart';
import 'package:coworking_space_app/app/modules/home/widgets/map_view.dart';
import 'package:coworking_space_app/app/modules/home/widgets/space_detail_screen.dart'; // Import the MapView

class BranchCard extends StatelessWidget {
  final CoworkingBranch branch;

  const BranchCard({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the SpaceDetailScreen when the card is tapped
        Get.to(() => SpaceDetailScreen(branch: branch));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                branch.images[0],
                fit: BoxFit.cover,
                // height: 120,
                width: double.infinity,
              ),
              Text(
                branch.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      branch.location,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to the MapView and pass the coordinates
                      Get.to(
                        () => MapView(initialPosition: branch.coordinates),
                      );
                    },
                    child: const Icon(
                      Icons.location_on_sharp,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '\$${branch.pricePerHour} / hour',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
