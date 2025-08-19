import 'package:coworking_space_app/app/modules/filter/filter_controller.dart';
import 'package:coworking_space_app/app/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homecontroller = Get.find<HomeController>();
    final controller = Get.put<FilterController>(FilterController());

    return Scaffold(
      appBar: AppBar(title: const Text('Filter Options'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'City',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Obx(
              () => DropdownButtonFormField<String>(
                value: controller.selectedCity.value,
                hint: const Text('Select a city'),
                onChanged: (String? newValue) {
                  controller.setCity(newValue);
                },
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('All Cities'),
                  ),
                  ...homecontroller.allBranches.map((branch) {
                    return DropdownMenuItem(
                      value: branch.city,
                      child: Text(branch.city),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Price per Hour',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Obx(
              () => RangeSlider(
                values: controller.selectedPrice.value,
                min: 0,
                max: 100,
                divisions: 10,
                labels: RangeLabels(
                  '\$${controller.selectedPrice.value.start.round()}',
                  '\$${controller.selectedPrice.value.end.round()}',
                ),
                onChanged: (RangeValues values) {
                  controller.setPriceRange(values);
                },
              ),
            ),
            Obx(
              () => Text(
                'Price Range: \$${controller.selectedPrice.value.start.round()} - \$${controller.selectedPrice.value.end.round()}',
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            homecontroller.applyFilters();
            Get.back();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            'Apply Filters',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
