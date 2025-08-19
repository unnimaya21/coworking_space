import 'package:coworking_space_app/app/modules/home/widgets/map_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coworking_space_app/app/modules/filter/filter_view.dart';
import 'package:coworking_space_app/app/modules/home/home_controller.dart';
import 'package:coworking_space_app/app/modules/home/widgets/branch_card.dart';
import 'package:coworking_space_app/app/modules/my_bookings/my_bookings.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coworking Spaces'),
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              Get.to(() => const FilterScreen());
            },
          ),
          IconButton(
            icon: const Icon(Icons.book_online),
            onPressed: () {
              Get.to(() => const MyBookingsScreen());
            },
          ),
          GestureDetector(
            onTap: () {
              // Navigate to the MapView and pass the coordinates
              Get.to(() => MapView());
            },
            child: const Icon(Icons.map),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => controller.searchBranches(value),
              decoration: const InputDecoration(
                labelText: 'Search by name, city, or location',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
            ),
          ),
          // Obx automatically rebuilds when the reactive variables change
          Obx(() {
            if (controller.isLoading.value) {
              return const Expanded(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (controller.filteredBranches.isEmpty) {
              return const Expanded(
                child: Center(child: Text('No branches found.')),
              );
            }

            return Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                shrinkWrap: true,
                children: [
                  for (var branch in controller.filteredBranches)
                    BranchCard(branch: branch),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
