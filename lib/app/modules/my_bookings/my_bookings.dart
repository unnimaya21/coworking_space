// lib/presentation/my_bookings/views/my_bookings_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coworking_space_app/app/modules/my_bookings/my_bookings_controller.dart';
import 'package:coworking_space_app/app/modules/widgets/text_widget.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller for this screen
    final controller = Get.put(MyBookingsController());

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings'), centerTitle: true),
      body: Obx(() {
        if (controller.allBookings.isEmpty) {
          return const Center(child: Text('You have no bookings yet.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextWidget(
                text: 'Upcoming Bookings',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 16),
              // Upcoming bookings list
              if (controller.upcomingBookings.isEmpty)
                const Text('You have no upcoming bookings.')
              else
                Wrap(
                  spacing: 20,
                  children: [
                    ...controller.upcomingBookings.map(
                      (booking) =>
                          BookingCard(booking: booking, isUpcoming: true),
                    ),
                  ],
                ),
              const SizedBox(height: 32),
              const Text(
                'Completed Bookings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Completed bookings list
              if (controller.completedBookings.isEmpty)
                const Text('You have no completed bookings.')
              else
                Wrap(
                  spacing: 20,

                  children: [
                    ...controller.completedBookings.map(
                      (booking) =>
                          BookingCard(booking: booking, isUpcoming: false),
                    ),
                  ],
                ),
            ],
          ),
        );
      }),
    );
  }
}

class BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final bool isUpcoming;

  const BookingCard({
    super.key,
    required this.booking,
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              booking['branch'] ?? 'N/A',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Date: ${booking['date'] ?? 'N/A'}'),
            Text('Time: ${booking['time'] ?? 'N/A'}'),
            Text('Price: \$${booking['price'] ?? 'N/A'}'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isUpcoming ? Colors.green : Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isUpcoming ? 'Upcoming' : 'Completed',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
