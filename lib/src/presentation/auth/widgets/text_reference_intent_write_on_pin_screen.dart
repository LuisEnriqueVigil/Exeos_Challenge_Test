import 'package:flutter/material.dart';

class TextReferenceIntentWriteOnPinScreen extends StatelessWidget {
  const TextReferenceIntentWriteOnPinScreen({
    super.key,
    required bool isLocked,
  }) : _isLocked = isLocked;

  final bool _isLocked;

  @override
  Widget build(BuildContext context) {
    return Text(
      _isLocked 
        ? 'Has excedido el número máximo de intentos'
        : 'Introduce el PIN de 4 dígitos',
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[600],
      ),
      textAlign: TextAlign.center,
    );
  }
}