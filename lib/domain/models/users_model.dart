import 'dart:convert';

class UserModel {
  final String name;
  final String password;
  final String email;
  final String? imageAsBase64;
  final String interestId;
  final String id;

  UserModel(
      {required this.name,
      required this.password,
      required this.email,
      required this.imageAsBase64,
      required this.interestId,
      required this.id});

  factory UserModel.fromJson(Map json) {
    return UserModel(
        id: json['id'].toString(),
        email: json['email'],
        imageAsBase64: json['imageAsBase64'] != null
            ? (base64.decode(json['imageAsBase64'].toString())).toString()
            : null,
        interestId: json['intrestId'],
        name: json['username'],
        password: json['password']);
  }
}
