// user_entity.dart

import 'package:coworking_space_app/app/data/models/user_model.dart';

class UserEntity {
  final int? errorCode;
  final String? message;
  final DataEntity? data;

  UserEntity({this.errorCode, this.message, this.data});

  factory UserEntity.fromModel(UserModel model) {
    return UserEntity(
      errorCode: model.errorCode,
      message: model.message,
      data: model.data != null ? DataEntity.fromModel(model.data!) : null,
    );
  }
}

class DataEntity {
  final String? accessToken;

  DataEntity({this.accessToken});

  factory DataEntity.fromModel(Data model) {
    return DataEntity(accessToken: model.accessToken);
  }
}
