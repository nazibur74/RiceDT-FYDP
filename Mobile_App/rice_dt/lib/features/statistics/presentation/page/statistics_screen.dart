import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rice_dt/core/theme/app_colors.dart';
import 'package:rice_dt/database/prediction_database.dart';
import 'package:rice_dt/database/statistics_data.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late Future<StatisticsData> _statistics;

  @override
  void initState() {
    super.initState();
    _statistics = PredictionDatabase.instance.getStatisticsData();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: AppColors.darkForest,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.darkForest, AppColors.leafGreen],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Statistics",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          "Your scan activity overview",
                          style: TextStyle(
                            color: AppColors.sageLight.withOpacity(0.85),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Body ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: FutureBuilder<StatisticsData>(
              future: _statistics,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 400,
                    child: Center(
                      child: CircularProgressIndicator(color: cs.primary),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return SizedBox(
                    height: 400,
                    child: Center(
                      child: Text(
                        "No statistics available.",
                        style: TextStyle(color: cs.onSurfaceVariant),
                      ),
                    ),
                  );
                }

                final stats = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _summaryCards(stats, cs),
                      const SizedBox(height: 28),
                      _sectionLabel(cs, "Overview"),
                      const SizedBox(height: 14),
                      _pieChartCard(stats, cs),
                      const SizedBox(height: 28),
                      _sectionLabel(cs, "Disease Breakdown"),
                      const SizedBox(height: 14),
                      _diseaseDistributionCard(stats, cs),
                      const SizedBox(height: 28),
                      _topDiseaseCard(stats),
                      const SizedBox(height: 32),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(ColorScheme cs, String label) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
        color: cs.primary,
      ),
    );
  }

  Widget _summaryCards(StatisticsData stats, ColorScheme cs) {
    return Row(
      children: [
        Expanded(
          child: _StatSummaryCard(
            label: "Total",
            value: stats.total.toString(),
            icon: Icons.analytics_rounded,
            iconColor: cs.primary,
            iconBg: cs.primaryContainer,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatSummaryCard(
            label: "Healthy",
            value: stats.healthy.toString(),
            icon: Icons.check_circle_rounded,
            iconColor: cs.primary,
            iconBg: cs.primaryContainer,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatSummaryCard(
            label: "Diseased",
            value: stats.diseased.toString(),
            icon: Icons.warning_amber_rounded,
            iconColor: AppColors.error,
            iconBg: AppColors.errorLight,
          ),
        ),
      ],
    );
  }

  Widget _pieChartCard(StatisticsData stats, ColorScheme cs) {
    final total = stats.healthy + stats.diseased;
    final healthyPct = total > 0
        ? (stats.healthy / total * 100).toStringAsFixed(1)
        : "0";
    final diseasedPct = total > 0
        ? (stats.diseased / total * 100).toStringAsFixed(1)
        : "0";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(cs),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 50,
                sections: [
                  PieChartSectionData(
                    value: stats.healthy.toDouble(),
                    color: AppColors.success,
                    title: "${stats.healthy}",
                    radius: 55,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: stats.diseased.toDouble(),
                    color: AppColors.error,
                    title: "${stats.diseased}",
                    radius: 55,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Legend(
                color: AppColors.success,
                label: "Healthy",
                pct: "$healthyPct%",
              ),
              const SizedBox(width: 24),
              _Legend(
                color: AppColors.error,
                label: "Diseased",
                pct: "$diseasedPct%",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _diseaseDistributionCard(StatisticsData stats, ColorScheme cs) {
    if (stats.diseaseCounts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: _cardDecoration(cs),
        child: Center(
          child: Text(
            "No disease data yet.",
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
        ),
      );
    }

    final maxVal = stats.diseaseCounts.values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(cs),
      child: Column(
        children: stats.diseaseCounts.entries.map((e) {
          final ratio = maxVal > 0 ? e.value / maxVal : 0.0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        e.key,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      "${e.value}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: cs.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: ratio,
                    minHeight: 7,
                    backgroundColor: cs.primaryContainer,
                    valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _topDiseaseCard(StatisticsData stats) {
    if (stats.diseaseCounts.isEmpty) return const SizedBox();

    final top = stats.diseaseCounts.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );

    // Top disease card always uses brand dark gradient — intentional
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.darkForest, AppColors.leafGreen],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: AppColors.riceGold,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "MOST DETECTED",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.3,
                    color: AppColors.sageLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  top.key,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "${top.value}",
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration(ColorScheme cs) {
    return BoxDecoration(
      color: cs.surface,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}

// ─── Stat Summary Card ────────────────────────────────────────────────────────

class _StatSummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  const _StatSummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Legend ───────────────────────────────────────────────────────────────────

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  final String pct;

  const _Legend({required this.color, required this.label, required this.pct});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 7),
        Text(
          "$label  ",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: cs.onSurfaceVariant,
          ),
        ),
        Text(
          pct,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
