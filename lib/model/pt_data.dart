class PtData {
  final int id;
  final String originalText;
  final String translatedText;

  PtData(this.id, this.originalText, this.translatedText);

  PtData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        originalText = json['originalText'],
        translatedText = json['translatedText'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'originalText': originalText,
        'translatedText': translatedText,
      };
}
