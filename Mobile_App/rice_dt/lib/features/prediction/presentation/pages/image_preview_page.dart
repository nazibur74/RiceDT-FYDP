import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rice_dt/ai/model_service.dart';
import 'package:rice_dt/features/prediction/presentation/pages/prediction_screen.dart';
import 'package:rice_dt/database/prediction_database.dart';
import 'package:rice_dt/database/prediction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rice_dt/features/settings/settings_provider.dart';
import 'package:rice_dt/core/theme/app_colors.dart';

class ImagePreviewPage extends ConsumerStatefulWidget {
  final String imagePath;

  const ImagePreviewPage({super.key, required this.imagePath});

  @override
  ConsumerState<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends ConsumerState<ImagePreviewPage> {
  bool _isAnalyzing = false;

  Future<void> _analyze() async {
    setState(() => _isAnalyzing = true);

    final saveImage = ref.read(saveImageProvider);

    try {
      final model = ModelService();
      final prediction = await model.predict(File(widget.imagePath));

      debugPrint("Prediction: ${prediction.label}");
      debugPrint("Confidence: ${prediction.confidence}");

      await PredictionDatabase.instance.insertPrediction(
        PredictionRecord(
          disease: prediction.label,
          confidence: prediction.confidence,
          imagePath: saveImage ? widget.imagePath : "",
          timestamp: DateTime.now(),
        ),
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PredictionScreen(
            imagePath: widget.imagePath,
            disease: prediction.label,
            confidence: prediction.confidence,
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isAnalyzing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // This screen is a camera viewfinder — background is always dark
    // regardless of theme. Only text/icon tokens inside panels adapt.
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      "Preview",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // ── Image ─────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(File(widget.imagePath), fit: BoxFit.cover),

                      // Vignette overlay
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.25),
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                      ),

                      // Scan frame corners
                      if (!_isAnalyzing)
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: CustomPaint(painter: _CornerPainter()),
                        ),

                      // Analyzing overlay
                      if (_isAnalyzing)
                        Container(
                          color: Colors.black.withOpacity(0.55),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: AppColors.sageLight,
                                strokeWidth: 3,
                              ),
                              SizedBox(height: 18),
                              Text(
                                "Analyzing leaf...",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Running MobileNetV3",
                                style: TextStyle(
                                  color: AppColors.sageLight,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Bottom panel ──────────────────────────────────────────
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                // Always dark — intentional camera UI panel
                color: AppColors.darkForest,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.leafGreen, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tip
                  Row(
                    children: [
                      const Icon(
                        Icons.tips_and_updates_rounded,
                        size: 14,
                        color: AppColors.sageLight,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Make sure the leaf is clearly visible",
                        style: TextStyle(
                          color: AppColors.sageLight.withOpacity(0.85),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Buttons
                  Row(
                    children: [
                      // Retake
                      Expanded(
                        child: GestureDetector(
                          onTap: _isAnalyzing ? null : () => context.pop(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.15),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Retake",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Analyze
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: _isAnalyzing ? null : _analyze,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              gradient: _isAnalyzing
                                  ? null
                                  : const LinearGradient(
                                      colors: [
                                        AppColors.leafGreen,
                                        AppColors.darkForest,
                                      ],
                                    ),
                              color: _isAnalyzing
                                  ? AppColors.leafGreen.withOpacity(0.4)
                                  : null,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: _isAnalyzing
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: AppColors.leafGreen.withOpacity(
                                          0.4,
                                        ),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.auto_awesome_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _isAnalyzing ? "Analyzing..." : "Analyze",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Corner Frame Painter ─────────────────────────────────────────────────────

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.sageLight.withOpacity(0.8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const len = 28.0;

    // Top-left
    canvas.drawLine(Offset.zero, const Offset(len, 0), paint);
    canvas.drawLine(Offset.zero, const Offset(0, len), paint);

    // Top-right
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - len, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, len), paint);

    // Bottom-left
    canvas.drawLine(Offset(0, size.height), Offset(len, size.height), paint);
    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - len),
      paint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - len, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - len),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
