import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:get_storage/get_storage.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/storage_keys.dart';
import '../providers/api_provider.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiProvider apiProvider;
  final GetStorage _storage = GetStorage();

  AuthRepositoryImpl({required this.apiProvider});

  @override
  Future<Either<String, UserEntity>> login({
    required String deviceToken,
    required int deviceType,
  }) async {
    try {
      final response = await apiProvider.post(
        ApiConstants.loginEndpoint,
        data: {'device_token': deviceToken, 'device_type': deviceType},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        log('Login successful: ${data.toString()}');

        // Store token and user data
        await _storage.write(StorageKeys.authToken, data['access_token'] ?? '');

        // Create UserModel and convert to UserEntity
        final userModel = UserModel.fromJson(data);
        final userEntity = UserEntity.fromModel(userModel);

        return Right(userEntity);
      } else {
        return Left(response.data['message'] ?? 'Login failed');
      }
    } catch (e) {
      return Left('Network error: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    await _storage.remove(StorageKeys.authToken);
    await _storage.remove(StorageKeys.userData);
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userData = _storage.read(StorageKeys.userData);
    if (userData != null) {
      // 1. Create a UserModel from the stored data
      final userModel = UserModel.fromJson(userData);

      // 2. Convert the UserModel to a UserEntity using the factory constructor
      return UserEntity.fromModel(userModel);
    }
    return null;
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = _storage.read(StorageKeys.authToken);
    return token != null;
  }
}
