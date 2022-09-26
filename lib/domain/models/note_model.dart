class NoteModel {
  final String id;
  final String text;
  final String placeDateTime;
  final String userId;

  NoteModel(
      {required this.id,
      required this.text,
      required this.placeDateTime,
      required this.userId});

  factory NoteModel.fromJson(Map json) {
    return NoteModel(
        id: json['id'].toString(),
        text: json['text'],
        placeDateTime: json['placeDateTime'],
        userId: json['userId'] ?? "0");
  }
}
