import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:coworking_space_app/app/domain/entities/branches.dart';

import '../../domain/repositories/home_repository.dart';
import '../providers/api_provider.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ApiProvider apiProvider;

  HomeRepositoryImpl({required this.apiProvider});

  @override
  Future<List<CoworkingBranch>> getBranches() async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 1));
    final String response = await rootBundle.loadString(
      'assets/json/branches.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => CoworkingBranch.fromJson(json)).toList();
  }
}
