import 'package:dartz/dartz.dart';
import '../entities/home_data_entity.dart';
import '../repositories/home_repository.dart';

class GetHomeDataUseCase {
  final HomeRepository repository;

  GetHomeDataUseCase({required this.repository});

  Future<Either<String, HomeDataEntity>> call() async {
    return await repository.getHomeData();
  }
}
