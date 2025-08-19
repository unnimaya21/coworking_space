import 'package:coworking_space_app/app/domain/entities/branches.dart';

abstract class HomeRepository {
  Future<List<CoworkingBranch>> getBranches();
}
