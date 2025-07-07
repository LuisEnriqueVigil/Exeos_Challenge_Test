import 'package:exeos_network_challenge/src/presentation/qr/screen/qr_scanner_screen.dart';
import 'package:flutter/material.dart';


class ReturnToOptionsScannerWidgetOnCrypoListScreen extends StatelessWidget {
  const ReturnToOptionsScannerWidgetOnCrypoListScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: ()async{
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const QrScannerScreen(),
            ),
          );
        },
        icon: const Icon(Icons.qr_code_scanner_outlined, size: 24),
        label: const Text(
          'Opciones de busqueda',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          shadowColor: Colors.blue.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
