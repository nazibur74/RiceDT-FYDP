import 'package:flutter/material.dart';

class BottomToolbar extends StatelessWidget {
  const BottomToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.flash_off, color: Colors.white),
          Icon(Icons.photo_library, color: Colors.white),
          Icon(Icons.cameraswitch, color: Colors.white),
        ],
      ),
    );
  }
}
