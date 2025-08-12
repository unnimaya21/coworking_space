import 'package:dartz/dartz.dart';
import '../entities/home_data_entity.dart';

abstract class HomeRepository {
  Future<Either<String, HomeDataEntity>> getHomeData();
}
