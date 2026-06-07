class HistoryModel {
  final int? id;
  final String originalFile;
  final String enhancedFile;
  final String createdAt;

  HistoryModel({
    this.id,
    required this.originalFile,
    required this.enhancedFile,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'originalFile': originalFile,
      'enhancedFile': enhancedFile,
      'createdAt': createdAt,
    };
  }

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      id: map['id'],
      originalFile: map['originalFile'],
      enhancedFile: map['enhancedFile'],
      createdAt: map['createdAt'],
    );
  }
}
