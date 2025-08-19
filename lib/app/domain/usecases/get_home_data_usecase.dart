import 'package:coworking_space_app/app/domain/entities/branches.dart';
import '../repositories/home_repository.dart';

class GetHomeDataUseCase {
  final HomeRepository repository;

  GetHomeDataUseCase({required this.repository});

  Future<List<CoworkingBranch>> call() async {
    return await repository.getBranches();
  }

  //The call() method in your GetHomeDataUseCase is an operator overloading feature
  //in Dart that allows you to call an instance of a class like a function.
}
