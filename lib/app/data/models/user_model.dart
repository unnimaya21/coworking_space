// import '../../domain/entities/user_entity.dart';

// class UserModel extends UserEntity {
//   const UserModel({super.id, super.name, super.email, super.token});

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['id']?.toString(),
//       name: json['name']?.toString(),
//       email: json['email']?.toString(),
//       token: json['token']?.toString(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {'id': id, 'name': name, 'email': email, 'token': token};
//   }
// }
class UserModel {
  int? errorCode;
  String? message;
  Data? data;

  UserModel({this.errorCode, this.message, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['error_code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error_code'] = errorCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? accessToken;

  Data({this.accessToken});

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    return data;
  }
}
