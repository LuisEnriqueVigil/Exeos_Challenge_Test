import 'dart:math' as math;

import 'package:flutter/material.dart';


class AnimationCentralOfScreenWidgetLoadingQrScannerScreen extends StatelessWidget {
  const AnimationCentralOfScreenWidgetLoadingQrScannerScreen({
    super.key,
    required Animation<double> pulseAnimation,
    required this.theme,
    required Animation<double> bounceAnimation,
    required Animation<double> rotationAnimation,
    required AnimationController rotationController,
  }) : _pulseAnimation = pulseAnimation, _bounceAnimation = bounceAnimation, _rotationAnimation = rotationAnimation, _rotationController = rotationController;

  final Animation<double> _pulseAnimation;
  final ThemeData theme;
  final Animation<double> _bounceAnimation;
  final Animation<double> _rotationAnimation;
  final AnimationController _rotationController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Círculo de fondo pulsante
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary.withAlpha(40),
                    border: Border.all(
                      color: theme.colorScheme.primary.withAlpha(40),
                      width: 2,
                    ),
                  ),
                ),
              );
            },
          ),
    
          // Moneda animada (rebote + rotación)
          AnimatedBuilder(
            animation: Listenable.merge([_bounceAnimation, _rotationAnimation]),
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _bounceAnimation.value),
                child: Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.amber.shade300,
                          Colors.amber.shade600,
                          Colors.orange.shade500,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withAlpha(40),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.monetization_on,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
    
          // Partículas flotantes alrededor
          ...List.generate(6, (index) {
            return AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                final angle = (_rotationAnimation.value + (index * math.pi / 3));
                final x = math.cos(angle) * 80;
                final y = math.sin(angle) * 80;
                
                return Transform.translate(
                  offset: Offset(x, y),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary.withAlpha(40),
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
