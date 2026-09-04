import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 90});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.eco_rounded,
      size: size,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
