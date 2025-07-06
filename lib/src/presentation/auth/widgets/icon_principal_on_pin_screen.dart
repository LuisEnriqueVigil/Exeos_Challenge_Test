import 'package:flutter/material.dart';

class IconPrincipalOnPinScreen extends StatelessWidget {
  const IconPrincipalOnPinScreen({
    super.key,
    required bool isLocked,
  }) : _isLocked = isLocked;

  final bool _isLocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _isLocked ? Colors.red[50] : Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        _isLocked ? Icons.lock : Icons.security,
        size: 60,
        color: _isLocked ? Colors.red : Colors.blue,
      ),
    );
  }
}
