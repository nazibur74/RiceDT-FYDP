import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/gallery_service.dart';
import '../controllers/scan_controller.dart';

class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({super.key});

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage> {
  final GalleryService _galleryService = GalleryService();

  bool _flashEnabled = false;
  bool _isCapturing = false;

  @override
  Widget build(BuildContext context) {
    final camera = ref.watch(scanControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Scan Leaf')),
      body: camera.when(
        data: (service) {
          return Stack(
            fit: StackFit.expand,
            children: [
              CameraPreview(service.controller!),

              // Leaf positioning guide
              IgnorePointer(
                child: Center(
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 3),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),

              // Instructions
              const Positioned(
                left: 20,
                right: 20,
                top: 24,
                child: Text(
                  'Place the rice leaf clearly inside the frame',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    shadows: [Shadow(blurRadius: 8, color: Colors.black)],
                  ),
                ),
              ),

              // Camera controls
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 22,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Flash
                        IconButton(
                          tooltip: 'Flash',
                          onPressed: () async {
                            try {
                              final enabled = await service.toggleFlash();

                              if (!mounted) return;

                              setState(() {
                                _flashEnabled = enabled;
                              });
                            } catch (e) {
                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Unable to change flash: $e'),
                                ),
                              );
                            }
                          },
                          icon: Icon(
                            _flashEnabled
                                ? Icons.flash_on_rounded
                                : Icons.flash_off_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),

                        // Capture
                        GestureDetector(
                          onTap: _isCapturing
                              ? null
                              : () async {
                                  setState(() {
                                    _isCapturing = true;
                                  });

                                  try {
                                    final image = await service.captureImage();

                                    if (!mounted) return;

                                    context.push('/preview', extra: image.path);
                                  } catch (e) {
                                    if (!mounted) return;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Could not capture image: $e',
                                        ),
                                      ),
                                    );
                                  } finally {
                                    if (mounted) {
                                      setState(() {
                                        _isCapturing = false;
                                      });
                                    }
                                  }
                                },
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 5,
                              ),
                            ),
                            child: _isCapturing
                                ? const Padding(
                                    padding: EdgeInsets.all(24),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                    ),
                                  )
                                : null,
                          ),
                        ),

                        // Gallery
                        IconButton(
                          tooltip: 'Gallery',
                          onPressed: () async {
                            try {
                              final image = await _galleryService.pickImage();

                              if (image == null || !mounted) {
                                return;
                              }

                              context.push('/preview', extra: image.path);
                            } catch (e) {
                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Could not open gallery: $e'),
                                ),
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.photo_library_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },

        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Camera error:\n$error', textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
