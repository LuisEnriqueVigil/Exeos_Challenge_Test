import 'package:flutter/material.dart';

class PinDotsOnPinScreen extends StatelessWidget {
  const PinDotsOnPinScreen({
    super.key,
    required Animation<double> shakeAnimation,
    required String currentPin,
    required bool isLocked,
  }) : _shakeAnimation = shakeAnimation, _currentPin = currentPin, _isLocked = isLocked;

  final Animation<double> _shakeAnimation;
  final String _currentPin;
  final bool _isLocked;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              bool isFilled = index < _currentPin.length;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFilled ? Colors.blue : Colors.transparent,
                  border: Border.all(
                    color: _isLocked ? Colors.red : Colors.blue,
                    width: 2,
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}