import 'package:flutter/material.dart';

class AnimateTextSearchingWidgetLoadingQrScannerScreen extends StatelessWidget {
  const AnimateTextSearchingWidgetLoadingQrScannerScreen({
    super.key,
    required Animation<double> fadeAnimation,
    required this.theme,
  }) : _fadeAnimation = fadeAnimation;

  final Animation<double> _fadeAnimation;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Text(
            'Buscando...',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        );
      },
    );
  }
}