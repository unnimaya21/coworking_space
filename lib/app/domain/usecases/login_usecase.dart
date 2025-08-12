import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<Either<String, UserEntity>> call({
    required String deviceToken,
    required int deviceType,
  }) async {
    return await repository.login(
      deviceToken: deviceToken,
      deviceType: deviceType,
    );
  }
}
