import 'package:flutter/material.dart';



class LabelReferenceAccessAccountOnPinScreen extends StatelessWidget {
  const LabelReferenceAccessAccountOnPinScreen({
    super.key,
    required bool isLocked,
  }) : _isLocked = isLocked;

  final bool _isLocked;

  @override
  Widget build(BuildContext context) {
    return Text(
      _isLocked ? 'Acceso Bloqueado' : 'Ingresa tu PIN',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: _isLocked ? Colors.red : Colors.black87,
      ),
      textAlign: TextAlign.center,
    );
  }
}
