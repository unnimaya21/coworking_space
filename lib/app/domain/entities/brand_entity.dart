import 'package:equatable/equatable.dart';

class BrandEntity extends Equatable {
  final String id;
  final String name;
  final String logo;
  final String? description;

  const BrandEntity({
    required this.id,
    required this.name,
    required this.logo,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, logo, description];
}
