class PredictionRecord {
  final int? id;
  final String disease;
  final double confidence;
  final String imagePath;
  final DateTime timestamp;

  const PredictionRecord({
    this.id,
    required this.disease,
    required this.confidence,
    required this.imagePath,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'disease': disease,
      'confidence': confidence,
      'imagePath': imagePath,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory PredictionRecord.fromMap(Map<String, dynamic> map) {
    return PredictionRecord(
      id: map['id'] as int?,
      disease: map['disease'] as String,
      confidence: (map['confidence'] as num).toDouble(),
      imagePath: map['imagePath'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
}
