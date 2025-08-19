import 'dart:developer';

import 'package:coworking_space_app/app/modules/filter/filter_controller.dart';
import 'package:coworking_space_app/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:get_storage/get_storage.dart';
import 'package:coworking_space_app/app/core/utils/storage_keys.dart';
import 'package:coworking_space_app/app/domain/entities/branches.dart';
import 'package:coworking_space_app/app/domain/usecases/get_home_data_usecase.dart';

class HomeController extends GetxController {
  final GetHomeDataUseCase _getHomeDataUseCase = Get.find();

  var isLoading = true.obs;
  var allBranches = <CoworkingBranch>[].obs;
  var filteredBranches = <CoworkingBranch>[].obs;
  var searchQuery = ''.obs;

  var selectedPrice = Rxn<RangeValues>();

  @override
  void onInit() {
    super.onInit();
    fetchBranches();
  }

  void fetchBranches() async {
    try {
      isLoading.value = true;
      final branches = await _getHomeDataUseCase.call();
      allBranches.assignAll(branches);
      filteredBranches.assignAll(branches);
      log('Fetched branches: ${branches.length}');
    } catch (e) {
      Get.snackbar('Error', 'Failed to load data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void searchBranches(String query) {
    searchQuery.value = query.toLowerCase();
    log('Search query updated: $query');
    applyFilters();
  }

  void applyFilters() {
    final filterController = Get.put(FilterController());
    filteredBranches.assignAll(
      allBranches.where((branch) {
        final query = searchQuery.value;
        final city = filterController.selectedCity.value;
        final priceRange = filterController.selectedPrice.value;

        // Check for search query match
        final bool matchesSearch =
            query.isEmpty ||
            branch.name.toLowerCase().contains(query) ||
            branch.location.toLowerCase().contains(query) ||
            branch.city.toLowerCase().contains(query);

        // Check for city filter match
        final bool matchesCity = city == null || branch.city == city;

        // Check for price filter match
        final bool matchesPrice =
            (branch.pricePerHour >= priceRange.start &&
                branch.pricePerHour <= priceRange.end);

        // A branch must match all criteria
        return matchesSearch && matchesCity && matchesPrice;
      }).toList(),
    );
  }

  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<String> selectedTime = ''.obs;

  late CoworkingBranch _branch;
  final GetStorage _storage = GetStorage();

  final List<String> availableTimeSlots = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '01:40 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
    '06:00 PM',
  ];

  void setBranch(CoworkingBranch branch) {
    _branch = branch;
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  void selectTime(String time) {
    selectedTime.value = time;
  }

  void bookSpace() {
    var notificationService = NotificationService();
    if (selectedTime.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a date and a time slot.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Create the booking details map
    final bookingDetails = {
      'branch': _branch.name,
      'date': selectedDate.value.toLocal().toString().split(' ')[0],
      'time': selectedTime.value,
      'price': _branch.pricePerHour,
    };

    // Get the current list of bookings from storage
    // If the key doesn't exist, it returns an empty list
    final List<dynamic> currentBookings =
        _storage.read<List<dynamic>>(StorageKeys.bookingsKey) ?? [];

    // Add the new booking to the list
    currentBookings.add(bookingDetails);

    // Save the updated list back to storage
    _storage.write(StorageKeys.bookingsKey, currentBookings);
    DateFormat formatter = DateFormat('yyyy-MM-dd h:mm a');
    final bookingDateTime = formatter.parse(
      '${bookingDetails['date']} ${bookingDetails['time']}',
    );
    notificationService.scheduleNotification(
      id: currentBookings.length, // Unique ID for each notification
      title: 'Booking Reminder',
      body:
          'Your booking at ${bookingDetails['branch']} is scheduled for today at ${bookingDetails['time']}.',
      scheduledDate: bookingDateTime.subtract(
        const Duration(minutes: 30),
      ), // 30 minutes before booking
    );

    notificationService.showNotification(
      id: 2001,
      title: 'Booking Confirmed!',
      body:
          'You have successfully booked a space at ${_branch.name} for ${selectedTime.value} on ${selectedDate.value.toLocal().toString().split(' ')[0]}.',
    );

    log('Stored Bookings: ${_storage.read(StorageKeys.bookingsKey)}');
  }
}
