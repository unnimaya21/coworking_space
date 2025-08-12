import 'package:dartz/dartz.dart';

import '../../domain/entities/home_data_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../../core/constants/api_constants.dart';
import '../providers/api_provider.dart';
import '../models/home_data_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ApiProvider apiProvider;

  HomeRepositoryImpl({required this.apiProvider});

  @override
  Future<Either<String, HomeDataEntity>> getHomeData() async {
    try {
      final response = await apiProvider.get(ApiConstants.homeEndpoint);

      if (response.statusCode == 200) {
        final homeDataModel = HomeDataModel.fromJson(
          response.data['data'] ?? response.data,
        );

        // Convert the model to an entity before returning
        final homeDataEntity = HomeDataEntity.fromModel(homeDataModel);

        return Right(homeDataEntity);
      } else {
        return Left(response.data['message'] ?? 'Failed to load home data');
      }
    } catch (e) {
      return Left('Network error: ${e.toString()}');
    }
  }
}
