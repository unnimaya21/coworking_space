import 'package:coworking_space_app/app/modules/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import Get for navigation
import 'package:coworking_space_app/app/domain/entities/branches.dart';
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
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Stack(
                children: [
                  Image.asset(
                    branch.images[0],
                    fit: BoxFit.cover,
                    // height: 120,
                    width: double.infinity,
                  ),
                  Positioned(
                    left: 5,
                    top: 10,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextWidget(
                        text: '${branch.pricePerHour} Rs/hour',
                        fontSize:
                            Theme.of(context).textTheme.labelMedium?.fontSize ??
                            12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              TextWidget(
                text: branch.name,
                fontSize:
                    Theme.of(context).textTheme.titleMedium?.fontSize ?? 13,
                fontWeight: FontWeight.bold,
              ),

              Row(
                children: [
                  Flexible(
                    child: TextWidget(
                      text: branch.location,
                      fontSize:
                          Theme.of(context).textTheme.labelSmall?.fontSize ??
                          12,
                      color: Colors.grey,

                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
