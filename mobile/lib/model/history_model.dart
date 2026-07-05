class HistoryModel {
  final int? id;

  final String originalFile;

  final String originalPath;

  final String enhancedFile;

  final double noiseReduction;

  final double audioEnhancement;

  final String createdAt;

  HistoryModel({
    this.id,
    required this.originalFile,
    required this.originalPath,
    required this.enhancedFile,
    required this.noiseReduction,
    required this.audioEnhancement,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'originalFile': originalFile,
      'originalPath': originalPath,
      'enhancedFile': enhancedFile,
      'noiseReduction': noiseReduction,
      'audioEnhancement': audioEnhancement,
      'createdAt': createdAt,
    };
  }

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      id: map['id'],
      originalFile: map['originalFile'],
      originalPath: map['originalPath'],
      enhancedFile: map['enhancedFile'],
      noiseReduction: (map['noiseReduction'] as num).toDouble(),
      audioEnhancement: (map['audioEnhancement'] as num).toDouble(),
      createdAt: map['createdAt'],
    );
  }
}
