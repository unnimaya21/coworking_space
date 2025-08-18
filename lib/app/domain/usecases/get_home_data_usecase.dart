import 'package:dartz/dartz.dart';
import '../entities/home_data_entity.dart';
import '../repositories/home_repository.dart';

class GetHomeDataUseCase {
  final HomeRepository repository;

  GetHomeDataUseCase({required this.repository});

  Future<Either<String, HomeDataEntity>> call() async {
    return await repository.getHomeData();
  }

  //The call() method in your GetHomeDataUseCase is an operator overloading feature
  //in Dart that allows you to call an instance of a class like a function.
}
