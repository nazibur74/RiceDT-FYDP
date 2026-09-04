import 'package:flutter/material.dart';
import 'package:rice_dt/core/theme/app_colors.dart';
import 'app_info.dart';

// ─── Animated fade+slide wrapper ─────────────────────────────────────────────

class _Reveal extends StatefulWidget {
  final Widget child;
  final int delay;

  const _Reveal({required this.child, this.delay = 0});

  @override
  State<_Reveal> createState() => _RevealState();
}

class _RevealState extends State<_Reveal> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

// ─── About Screen ─────────────────────────────────────────────────────────────

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildHeader(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                children: const [
                  _Reveal(delay: 100, child: AppInfoCard()),
                  SizedBox(height: 20),
                  _Reveal(delay: 180, child: AIModelCard()),
                  SizedBox(height: 20),
                  _Reveal(delay: 260, child: DatasetCard()),
                  SizedBox(height: 20),
                  _Reveal(delay: 340, child: DeveloperCard()),
                  SizedBox(height: 20),
                  _Reveal(delay: 420, child: TechnologiesCard()),
                  SizedBox(height: 32),
                  _Reveal(delay: 500, child: FooterWidget()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildHeader() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 200,
      backgroundColor: AppColors.darkForest,
      leading: const BackButton(color: Colors.white),
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
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.15),
                          ),
                        ),
                        child: const Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.sageLight,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "About ${AppInfo.appName}".toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.sageLight,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "${AppInfo.tagline}\nUsing Artificial Intelligence",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Version ${AppInfo.version}",
                      style: const TextStyle(
                        color: AppColors.sageLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Tappable About Card ──────────────────────────────────────────────────────

class AboutCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const AboutCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  State<AboutCard> createState() => _AboutCardState();
}

class _AboutCardState extends State<AboutCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.02,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.98).animate(_pressCtrl);
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTapDown: (_) => _pressCtrl.forward(),
      onTapUp: (_) => _pressCtrl.reverse(),
      onTapCancel: () => _pressCtrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card header
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: cs.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(widget.icon, color: cs.primary, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(padding: const EdgeInsets.all(18), child: widget.child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── App Info Card ────────────────────────────────────────────────────────────

class AppInfoCard extends StatelessWidget {
  const AppInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AboutCard(
      icon: Icons.eco_rounded,
      title: "Application",
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(Icons.grass_rounded, size: 42, color: cs.primary),
                ),
                const SizedBox(height: 14),
                Text(
                  AppInfo.appName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${AppInfo.tagline} using AI",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cs.onSurfaceVariant,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(
                child: _InfoTile(title: "Version", value: AppInfo.version),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _InfoTile(title: "Platform", value: "Android"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── AI Model Card ────────────────────────────────────────────────────────────

class AIModelCard extends StatelessWidget {
  const AIModelCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AboutCard(
      icon: Icons.memory_rounded,
      title: "AI Model",
      child: Column(
        children: [
          _InfoRow(label: "Model", value: AppInfo.model),
          const _RowDivider(),
          _InfoRow(label: "Framework", value: AppInfo.framework),
          const _RowDivider(),
          _InfoRow(label: "Input Size", value: AppInfo.inputSize),
          const _RowDivider(),
          _InfoRow(
            label: "Output Classes",
            value: AppInfo.outputClasses.toString(),
          ),
          const _RowDivider(),
          _InfoRow(label: "Test Accuracy", value: AppInfo.accuracy),
        ],
      ),
    );
  }
}

// ─── Dataset Card ─────────────────────────────────────────────────────────────

class DatasetCard extends StatelessWidget {
  const DatasetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AboutCard(
      icon: Icons.dataset_rounded,
      title: "Dataset",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(label: "Dataset", value: AppInfo.datasetName),
          const _RowDivider(),
          _InfoRow(
            label: "Total Images",
            value: AppInfo.totalImages.toString(),
          ),
          const SizedBox(height: 20),
          _AnimatedDatasetItem(
            "Healthy",
            AppInfo.healthy,
            AppColors.leafGreen,
            AppInfo.totalImages,
            0,
          ),
          _AnimatedDatasetItem(
            "Blast",
            AppInfo.blast,
            Colors.orange,
            AppInfo.totalImages,
            80,
          ),
          _AnimatedDatasetItem(
            "Brown Spot",
            AppInfo.brownSpot,
            Colors.brown,
            AppInfo.totalImages,
            160,
          ),
          _AnimatedDatasetItem(
            "Bacterial Blight",
            AppInfo.bacterialBlight,
            AppColors.error,
            AppInfo.totalImages,
            240,
          ),
          _AnimatedDatasetItem(
            "Tungro",
            AppInfo.tungro,
            Colors.deepPurple,
            AppInfo.totalImages,
            320,
          ),
        ],
      ),
    );
  }
}

class _AnimatedDatasetItem extends StatefulWidget {
  final String disease;
  final int count;
  final Color color;
  final int total;
  final int delay;

  const _AnimatedDatasetItem(
    this.disease,
    this.count,
    this.color,
    this.total,
    this.delay,
  );

  @override
  State<_AnimatedDatasetItem> createState() => _AnimatedDatasetItemState();
}

class _AnimatedDatasetItemState extends State<_AnimatedDatasetItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _barAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _barAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);

    Future.delayed(Duration(milliseconds: widget.delay + 300), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ratio = widget.total > 0 ? widget.count / widget.total : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.disease,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: cs.onSurface,
                  ),
                ),
              ),
              Text(
                widget.count.toString(),
                style: TextStyle(
                  color: widget.color,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          AnimatedBuilder(
            animation: _barAnim,
            builder: (context, _) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _barAnim.value * ratio,
                  minHeight: 5,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.color.withOpacity(0.7),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Developer Card ───────────────────────────────────────────────────────────

class DeveloperCard extends StatelessWidget {
  const DeveloperCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AboutCard(
      icon: Icons.person_rounded,
      title: "Developer",
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: 38,
                    color: cs.primary,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  AppInfo.developer,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppInfo.degree,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cs.onSurfaceVariant,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppInfo.university,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: cs.primary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(
                child: _InfoTile(title: "Project", value: AppInfo.project),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _InfoTile(title: "Year", value: AppInfo.year),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Technologies Card ────────────────────────────────────────────────────────

class TechnologiesCard extends StatelessWidget {
  const TechnologiesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AboutCard(
      icon: Icons.code_rounded,
      title: "Technologies",
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: AppInfo.technologies.map((tech) => _TechChip(tech)).toList(),
      ),
    );
  }
}

// ─── Footer ───────────────────────────────────────────────────────────────────

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        const _PulsingHeart(),
        const SizedBox(height: 10),
        Text(
          "Built with Flutter & ${AppInfo.framework}",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "© ${AppInfo.year} Nazibur Rahman. All rights reserved.",
          style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

class _PulsingHeart extends StatefulWidget {
  const _PulsingHeart();

  @override
  State<_PulsingHeart> createState() => _PulsingHeartState();
}

class _PulsingHeartState extends State<_PulsingHeart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _scale = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: const Icon(Icons.favorite_rounded, color: Colors.red, size: 20),
    );
  }
}

// ─── Shared small widgets ─────────────────────────────────────────────────────

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const _InfoTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: cs.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Theme.of(context).scaffoldBackgroundColor,
      thickness: 1.5,
    );
  }
}

class _TechChip extends StatelessWidget {
  final String label;

  const _TechChip(this.label);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outline),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: cs.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
