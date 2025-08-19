import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coworking_space_app/app/domain/entities/branches.dart';
import 'package:coworking_space_app/app/modules/home/home_controller.dart';

class BookingScreen extends StatelessWidget {
  final CoworkingBranch branch;

  const BookingScreen({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller for this screen
    final controller = Get.put(HomeController());
    // Set the initial branch to the controller
    controller.setBranch(branch);

    return Scaffold(
      appBar: AppBar(title: Text('Book ${branch.name}'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a Date',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Button to show the DatePicker
            Obx(
              () => ElevatedButton.icon(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: controller.selectedDate.value,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (pickedDate != null) {
                    controller.selectDate(pickedDate);
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  controller.selectedDate.value.toLocal().toString().split(
                    ' ',
                  )[0],
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Select a Time Slot',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Time slot selection using a Wrap widget for flexible layout
            Obx(
              () => Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children:
                    controller.availableTimeSlots.map((timeSlot) {
                      final isSelected =
                          controller.selectedTime.value == timeSlot;
                      return GestureDetector(
                        onTap: () {
                          controller.selectTime(timeSlot);
                        },
                        child: Chip(
                          label: Text(timeSlot),
                          backgroundColor:
                              isSelected ? Colors.blue : Colors.grey[200],
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color:
                                  isSelected ? Colors.blue : Colors.transparent,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 32),
            // Display booking summary
            Obx(
              () => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Branch: ${branch.name}'),
                    Text(
                      'Date: ${controller.selectedDate.value.toLocal().toString().split(' ')[0]}',
                    ),
                    Text('Time Slot: ${controller.selectedTime.value}'),
                    Text('Price: ${branch.pricePerHour} Rs/hour'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            controller.bookSpace();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            'Confirm Booking',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
