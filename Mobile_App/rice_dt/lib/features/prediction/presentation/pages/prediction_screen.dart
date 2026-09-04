import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rice_dt/ai/disease_database.dart';
import 'package:rice_dt/core/theme/app_colors.dart';

class PredictionScreen extends StatelessWidget {
  final String imagePath;
  final String disease;
  final double confidence;

  const PredictionScreen({
    super.key,
    required this.imagePath,
    required this.disease,
    required this.confidence,
  });

  // Disease colors are semantic — fixed values, not theme tokens
  Color get diseaseColor =>
      disease == "Healthy" ? AppColors.success : AppColors.error;

  Color get diseaseLightColor =>
      disease == "Healthy" ? AppColors.successLight : AppColors.errorLight;

  IconData get diseaseIcon => disease == "Healthy"
      ? Icons.check_circle_rounded
      : Icons.warning_amber_rounded;

  String get confidenceLevel {
    if (confidence >= 0.90) return "Very High";
    if (confidence >= 0.75) return "High";
    if (confidence >= 0.60) return "Moderate";
    return "Low";
  }

  String get predictionMessage {
    if (disease == "Healthy") {
      return "The rice leaf appears healthy. No disease symptoms were detected.";
    }
    return "Disease symptoms were detected. Please review the treatment and prevention recommendations below.";
  }

  @override
  Widget build(BuildContext context) {
    final info = DiseaseDatabase.get(disease);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // ── Hero Image AppBar ────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.darkForest,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              "Prediction Result",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: imagePath,
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Result Badge Card ──────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Icon
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: diseaseLightColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            diseaseIcon,
                            color: diseaseColor,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Disease name
                        Text(
                          info.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: diseaseColor,
                            height: 1.2,
                          ),
                        ),
                        if (info.scientificName.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            info.scientificName,
                            style: TextStyle(
                              color: cs.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                              fontSize: 13,
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),

                        // Confidence bar
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: LinearProgressIndicator(
                                  value: confidence,
                                  minHeight: 8,
                                  backgroundColor: cs.onSurface.withOpacity(
                                    0.08,
                                  ),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    diseaseColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "${(confidence * 100).toStringAsFixed(1)}%",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: diseaseColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Confidence pill
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: diseaseLightColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "$confidenceLevel Confidence",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: diseaseColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Message banner
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: diseaseLightColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                disease == "Healthy"
                                    ? Icons.verified_rounded
                                    : Icons.info_outline_rounded,
                                color: diseaseColor,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  predictionMessage,
                                  style: TextStyle(
                                    fontSize: 13,
                                    height: 1.5,
                                    color: diseaseColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Info Sections ────────────────────────────────────────
                  _InfoSection(
                    icon: Icons.description_rounded,
                    title: "Description",
                    titleBn: "বর্ণনা",
                    accentColor: diseaseColor,
                    child: Column(
                      children: [
                        _LangTextCard(lang: "বাংলা", body: info.descriptionBn),
                        _LangTextCard(
                          lang: "English",
                          body: info.descriptionEn,
                        ),
                      ],
                    ),
                  ),

                  _InfoSection(
                    icon: Icons.coronavirus_rounded,
                    title: "Symptoms",
                    titleBn: "লক্ষণসমূহ",
                    accentColor: diseaseColor,
                    child: Column(
                      children: [
                        _LangBulletCard(
                          lang: "বাংলা",
                          items: info.symptomsBn,
                          color: diseaseColor,
                        ),
                        _LangBulletCard(
                          lang: "English",
                          items: info.symptomsEn,
                          color: diseaseColor,
                        ),
                      ],
                    ),
                  ),

                  _InfoSection(
                    icon: Icons.science_rounded,
                    title: "Causes",
                    titleBn: "কারণসমূহ",
                    accentColor: diseaseColor,
                    child: Column(
                      children: [
                        _LangBulletCard(
                          lang: "বাংলা",
                          items: info.causesBn,
                          color: diseaseColor,
                        ),
                        _LangBulletCard(
                          lang: "English",
                          items: info.causesEn,
                          color: diseaseColor,
                        ),
                      ],
                    ),
                  ),

                  _InfoSection(
                    icon: Icons.medication_rounded,
                    title: "Treatment",
                    titleBn: "চিকিৎসা",
                    accentColor: diseaseColor,
                    child: Column(
                      children: [
                        _LangBulletCard(
                          lang: "বাংলা",
                          items: info.treatmentBn,
                          color: diseaseColor,
                        ),
                        _LangBulletCard(
                          lang: "English",
                          items: info.treatmentEn,
                          color: diseaseColor,
                        ),
                      ],
                    ),
                  ),

                  _InfoSection(
                    icon: Icons.shield_rounded,
                    title: "Prevention",
                    titleBn: "প্রতিরোধ",
                    accentColor: diseaseColor,
                    child: Column(
                      children: [
                        _LangBulletCard(
                          lang: "বাংলা",
                          items: info.preventionBn,
                          color: diseaseColor,
                        ),
                        _LangBulletCard(
                          lang: "English",
                          items: info.preventionEn,
                          color: diseaseColor,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Bottom Actions ─────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.popUntil(
                            context,
                            (route) => route.isFirst,
                          ),
                          icon: const Icon(Icons.home_rounded),
                          label: const Text("Home"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: cs.onSurface,
                            side: BorderSide(color: cs.primary),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.camera_alt_rounded),
                          label: const Text("Scan Again"),
                          style: FilledButton.styleFrom(
                            backgroundColor: cs.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Info Section Wrapper ─────────────────────────────────────────────────────

class _InfoSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String titleBn;
  final Color accentColor;
  final Widget child;

  const _InfoSection({
    required this.icon,
    required this.title,
    required this.titleBn,
    required this.accentColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, color: accentColor, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                "/ $titleBn",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ─── Language Text Card ───────────────────────────────────────────────────────

class _LangTextCard extends StatelessWidget {
  final String lang;
  final String body;

  const _LangTextCard({required this.lang, required this.body});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LangChip(lang: lang),
          const SizedBox(height: 8),
          Text(
            body,
            style: TextStyle(fontSize: 15, height: 1.6, color: cs.onSurface),
          ),
        ],
      ),
    );
  }
}

// ─── Language Bullet Card ─────────────────────────────────────────────────────

class _LangBulletCard extends StatelessWidget {
  final String lang;
  final List<String> items;
  final Color color;

  const _LangBulletCard({
    required this.lang,
    required this.items,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LangChip(lang: lang),
          const SizedBox(height: 10),
          ...items.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      e,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: cs.onSurface,
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

// ─── Language Chip ────────────────────────────────────────────────────────────

class _LangChip extends StatelessWidget {
  final String lang;
  const _LangChip({required this.lang});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outline),
      ),
      child: Text(
        lang,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: cs.primary,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
