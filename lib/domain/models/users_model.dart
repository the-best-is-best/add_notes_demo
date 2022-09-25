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
}
