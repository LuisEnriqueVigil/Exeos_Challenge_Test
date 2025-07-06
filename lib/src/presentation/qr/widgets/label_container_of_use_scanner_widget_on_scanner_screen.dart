import 'package:flutter/material.dart';


class LabelContainerOfUseScannerWidgetOnScannerScreen extends StatelessWidget {
  const LabelContainerOfUseScannerWidgetOnScannerScreen({
    super.key,
    required this.boxHeigthSmall,
  });

  final double boxHeigthSmall;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(Icons.info_outline, color: Colors.blue[600], size: 24),
          SizedBox(height: boxHeigthSmall),
          const Text(
            'Compatible con todas las plataformas',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: boxHeigthSmall),
          Text(
            'Este scanner funciona en Windows Desktop, Android',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
