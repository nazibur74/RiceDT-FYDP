import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rice_dt/features/history/history_screen.dart';
import 'package:rice_dt/database/prediction_database.dart';
import 'package:rice_dt/database/dashboard_statistics.dart';
import 'package:rice_dt/features/statistics/presentation/page/statistics_screen.dart';
import 'package:rice_dt/features/about/about_screen.dart';
import 'package:rice_dt/features/settings/settings_screen.dart';
import 'package:rice_dt/core/theme/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late Future<DashboardStatistics> _statistics;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Slogan crossfade
  late AnimationController _sloganController;
  late Animation<double> _sloganFade;
  bool _showBangla = false;

  static const _englishSlogan = "Healthy Leaves, Healthy Harvests";
  static const _englishSub = "Protect your crops with the help of AI";
  static const _banglaSlogan = "সুস্থ পাতা, সুস্থ ফসল";
  static const _banglaSub = "আপনার ফসল রক্ষা করুন AI-এর সাহায্যে";

  @override
  void initState() {
    super.initState();
    _statistics = PredictionDatabase.instance.getStatistics();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Slogan fade controller
    _sloganController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _sloganFade = CurvedAnimation(
      parent: _sloganController,
      curve: Curves.easeInOut,
    );

    _startSloganCycle();
  }

  Future<void> _startSloganCycle() async {
    while (mounted) {
      // Show current slogan
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) break;

      // Fade out
      await _sloganController.forward();
      if (!mounted) break;

      // Switch slogan
      setState(() {
        _showBangla = !_showBangla;
      });

      // Fade in
      await _sloganController.reverse();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _sloganController.dispose();
    super.dispose();
  }

  Future<void> _loadStatistics() async {
    setState(() {
      _statistics = PredictionDatabase.instance.getStatistics();
    });
  }

  Future<void> _openScan() async {
    await context.push('/scan');
    await _loadStatistics();
  }

  void _push(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // ── Hero Header ───────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 210,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.darkForest,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white,
                ),
                onPressed: () => _push(const AboutScreen()),
              ),
              IconButton(
                icon: const Icon(Icons.settings_rounded, color: Colors.white),
                onPressed: () => _push(const SettingsScreen()),
              ),
              const SizedBox(width: 4),
            ],
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
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),

                        // App badge
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.sageLight.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.grass_rounded,
                                color: AppColors.sageLight,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "RiceDT",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          height: 90, // Reserve space for both slogans
                          child: FadeTransition(
                            opacity: Tween<double>(
                              begin: 1.0,
                              end: 0.0,
                            ).animate(_sloganFade),
                            child: AnimatedSwitcher(
                              duration: Duration.zero,
                              child: _showBangla
                                  ? _SloganBlock(
                                      key: const ValueKey('bangla'),
                                      title: _banglaSlogan,
                                      subtitle: _banglaSub,
                                    )
                                  : _SloganBlock(
                                      key: const ValueKey('english'),
                                      title: _englishSlogan,
                                      subtitle: _englishSub,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Scan button ──────────────────────────────────
                  GestureDetector(
                    onTap: _openScan,
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) => Transform.scale(
                        scale: _pulseAnimation.value,
                        child: child,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 68,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.leafGreen, AppColors.darkForest],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.leafGreen.withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Scan Leaf",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Quick actions ────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _QuickAction(
                          icon: Icons.history_rounded,
                          label: "History",
                          onTap: () => _push(const HistoryScreen()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickAction(
                          icon: Icons.bar_chart_rounded,
                          label: "Statistics",
                          onTap: () => _push(const StatisticsScreen()),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ── Section label ────────────────────────────────
                  Text(
                    "TODAY'S ACTIVITY",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      color: cs.primary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Stats ────────────────────────────────────────
                  FutureBuilder<DashboardStatistics>(
                    future: _statistics,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(color: cs.primary),
                        );
                      }
                      final stats = snapshot.data!;
                      return Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              icon: Icons.analytics_outlined,
                              label: "Total",
                              value: "${stats.total}",
                              iconColor: cs.primary,
                              iconBg: cs.primaryContainer,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.check_circle_outline_rounded,
                              label: "Healthy",
                              value: "${stats.healthy}",
                              iconColor: AppColors.success,
                              iconBg: AppColors.successLight,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.warning_amber_rounded,
                              label: "Diseased",
                              value: "${stats.diseased}",
                              iconColor: AppColors.error,
                              iconBg: AppColors.errorLight,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // ── Model badge ──────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cs.outline, width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: cs.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.memory_rounded,
                            size: 18,
                            color: cs.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Current AI Model",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: cs.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "RiceDT Model v1.0",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: cs.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: cs.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Active",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: cs.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Slogan Block ─────────────────────────────────────────────────────────────

class _SloganBlock extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SloganBlock({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            color: AppColors.sageLight.withOpacity(0.85),
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

// ─── Quick Action ─────────────────────────────────────────────────────────────

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outline, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: cs.primary, size: 18),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Stat Card ────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final Color iconBg;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
              height: 1,
            ),
          ),
          const SizedBox(height: 3),
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
