class InterestedModel {
  final String interestText;
  final String id;

  InterestedModel({required this.interestText, required this.id});

  factory InterestedModel.fromJson(Map json) {
    return InterestedModel(
        id: json['id'].toString(), interestText: json["intrestText"]);
  }
}
