import 'package:flutter/material.dart';
import 'settings_tile.dart';
import 'settings_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../database/prediction_database.dart';
import '../../features/settings/settings_provider.dart';
import '../../features/about/about_screen.dart';

// ─── Reveal animation wrapper ─────────────────────────────────────────────────

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
      duration: const Duration(milliseconds: 450),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.1),
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

// ─── Settings Screen ──────────────────────────────────────────────────────────

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                          "Settings",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          "Manage your preferences",
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Appearance ──────────────────────────────────────
                  _Reveal(
                    delay: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SettingsSection(title: "Appearance"),
                        const SizedBox(height: 8),
                        _GroupCard(
                          children: [
                            SettingsTile(
                              icon: Icons.dark_mode_rounded,
                              title: "Dark Mode",
                              subtitle: "Switch between light and dark theme",
                              trailing: Switch(
                                value:
                                    ref.watch(themeProvider) == ThemeMode.dark,
                                onChanged: (value) {
                                  ref
                                      .read(themeProvider.notifier)
                                      .setTheme(
                                        value
                                            ? ThemeMode.dark
                                            : ThemeMode.light,
                                      );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Prediction ──────────────────────────────────────
                  _Reveal(
                    delay: 160,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SettingsSection(title: "Prediction"),
                        const SizedBox(height: 8),
                        _GroupCard(
                          children: [
                            SettingsTile(
                              icon: Icons.image_rounded,
                              title: "Save Scan Image",
                              subtitle: "Store scanned images with prediction",
                              trailing: Switch(
                                value: ref.watch(saveImageProvider),
                                onChanged: (value) {
                                  ref
                                      .read(saveImageProvider.notifier)
                                      .toggle(value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Data ────────────────────────────────────────────
                  _Reveal(
                    delay: 240,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SettingsSection(title: "Data"),
                        const SizedBox(height: 8),
                        _GroupCard(
                          children: [
                            SettingsTile(
                              icon: Icons.delete_forever_rounded,
                              title: "Clear History",
                              subtitle: "Delete all prediction history",
                              trailing: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: cs.onSurfaceVariant,
                              ),
                              onTap: () => _showClearHistoryDialog(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Application ─────────────────────────────────────
                  _Reveal(
                    delay: 320,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SettingsSection(title: "Application"),
                        const SizedBox(height: 8),
                        _GroupCard(
                          children: [
                            SettingsTile(
                              icon: Icons.info_outline_rounded,
                              title: "About",
                              subtitle: "Application information",
                              trailing: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: cs.onSurfaceVariant,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AboutScreen(),
                                  ),
                                );
                              },
                            ),
                            SettingsTile(
                              icon: Icons.star_rate_rounded,
                              title: "Rate App",
                              subtitle: "Support the project",
                              trailing: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: cs.onSurfaceVariant,
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "This feature will be available in a future update.",
                                    ),
                                  ),
                                );
                              },
                            ),
                            SettingsTile(
                              icon: Icons.share_rounded,
                              title: "Share App",
                              subtitle: "Share Rice DT with friends",
                              trailing: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: cs.onSurfaceVariant,
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "This feature will be available in a future update.",
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ── Footer ──────────────────────────────────────────
                  _Reveal(
                    delay: 400,
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: cs.primaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.grass_rounded,
                              size: 28,
                              color: cs.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Rice DT",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Version 1.0.0",
                            style: TextStyle(
                              color: cs.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
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

// ─── Group Card wrapper ───────────────────────────────────────────────────────

class _GroupCard extends StatelessWidget {
  final List<Widget> children;

  const _GroupCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            for (int i = 0; i < children.length; i++) ...[
              children[i],
              if (i < children.length - 1)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  indent: 54,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Clear History Dialog ─────────────────────────────────────────────────────

Future<void> _showClearHistoryDialog(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      final cs = Theme.of(context).colorScheme;

      return AlertDialog(
        backgroundColor: cs.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Clear History",
          style: TextStyle(fontWeight: FontWeight.w700, color: cs.onSurface),
        ),
        content: Text(
          "Are you sure you want to delete all prediction history?\n\nThis action cannot be undone.",
          style: TextStyle(color: cs.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel", style: TextStyle(color: cs.primary)),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text("Delete"),
          ),
        ],
      );
    },
  );

  if (confirmed != true) return;

  await PredictionDatabase.instance.clearHistory();

  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Prediction history cleared successfully."),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
