class UploadResponseModel {
  final String message;
  final String originalName;
  final String storedOriginalFile;
  final String enhancedFile;
  final double noiseReduction;
  final double audioEnhancement;

  const UploadResponseModel({
    required this.message,
    required this.originalName,
    required this.storedOriginalFile,
    required this.enhancedFile,
    required this.noiseReduction,
    required this.audioEnhancement,
  });

  factory UploadResponseModel.fromJson(Map<String, dynamic> json) {
    return UploadResponseModel(
      message: json["message"],
      originalName: json["original_name"],
      storedOriginalFile: json["stored_original_file"],
      enhancedFile: json["enhanced_file"],
      noiseReduction: (json["noise_reduction"] as num).toDouble(),
      audioEnhancement: (json["audio_enhancement"] as num).toDouble(),
    );
  }
}
