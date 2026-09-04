class DiseaseInfo {
  final String name;
  final String scientificName;

  final String descriptionEn;
  final String descriptionBn;

  final List<String> symptomsEn;
  final List<String> symptomsBn;

  final List<String> causesEn;
  final List<String> causesBn;

  final List<String> treatmentEn;
  final List<String> treatmentBn;

  final List<String> preventionEn;
  final List<String> preventionBn;

  const DiseaseInfo({
    required this.name,
    required this.scientificName,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.symptomsEn,
    required this.symptomsBn,
    required this.causesEn,
    required this.causesBn,
    required this.treatmentEn,
    required this.treatmentBn,
    required this.preventionEn,
    required this.preventionBn,
  });
}
