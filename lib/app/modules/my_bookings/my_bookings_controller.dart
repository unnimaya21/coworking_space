import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:coworking_space_app/app/core/utils/storage_keys.dart';

class MyBookingsController extends GetxController {
  final GetStorage _storage = GetStorage();

  final RxList<dynamic> allBookings = <dynamic>[].obs;
  final RxList<dynamic> upcomingBookings = <dynamic>[].obs;
  final RxList<dynamic> completedBookings = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  void fetchBookings() {
    // Retrieve the stored bookings list
    final List<dynamic> storedBookings =
        _storage.read<List<dynamic>>(StorageKeys.bookingsKey) ?? [];

    // Clear previous lists
    allBookings.clear();
    upcomingBookings.clear();
    completedBookings.clear();

    // Use RxList to manage state and automatically update the UI
    allBookings.assignAll(storedBookings);

    // Filter the bookings based on their date
    final now = DateTime.now();
    final DateFormat dateTimeFormatter = DateFormat('yyyy-MM-dd h:mm a');

    for (var booking in allBookings) {
      if (booking['date'] != null) {
        try {
          final bookingDate = dateTimeFormatter.parse(
            '${booking['date']} ${booking['time']}',
          );
          if (bookingDate.isAfter(now)) {
            upcomingBookings.add(booking);
          } else {
            completedBookings.add(booking);
          }
        } catch (e) {
          // Handle parsing errors gracefully
          log('Error parsing booking date: $e');
        }
      }
    }
  }
}
