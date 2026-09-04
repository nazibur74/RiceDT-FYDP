class AppInfo {
  // ===========================
  // Application
  // ===========================
  static const appName = "RiceDT";
  static const tagline = "Rice Leaf Disease Detection";
  static const version = "1.0.0";

  // ===========================
  // AI Model
  // ===========================
  static const model = "RiceDT Model v1.0";
  static const framework = "TensorFlow Lite";
  static const inputSize = "224 × 224";
  static const outputClasses = 5;
  static const accuracy = "99.77%";

  // ===========================
  // Dataset
  // ===========================
  static const datasetName = "Rice Leaf Disease Dataset";

  static const healthy = 1081;
  static const bacterialBlight = 1584;
  static const blast = 1440;
  static const brownSpot = 1600;
  static const tungro = 1308;

  static const totalImages = 7013;

  // ===========================
  // Developer
  // ===========================
  static const developer = "Team Flamingo";
  static const degree = "B.Sc. in Computer Science & Engineering";
  static const department = "Department of Computer Science & Engineering";
  static const university = "Daffodil International University";
  static const project = "FYDP";
  static const year = "2026";

  // ===========================
  // Technologies
  // ===========================
  static const technologies = [
    "Flutter",
    "Dart",
    "TensorFlow Lite",
    "SQLite",
    "Image Picker",
    "Material Design",
  ];
}
