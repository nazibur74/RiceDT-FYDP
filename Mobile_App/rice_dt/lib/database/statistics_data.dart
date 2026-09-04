class StatisticsData {
  final int total;
  final int healthy;
  final int diseased;
  final Map<String, int> diseaseCounts;

  const StatisticsData({
    required this.total,
    required this.healthy,
    required this.diseased,
    required this.diseaseCounts,
  });
}
