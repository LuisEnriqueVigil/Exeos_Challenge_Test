import 'package:exeos_network_challenge/src/domain/controllers/qr/qr_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ReturnToScannerQrWidgetOnCryptoListScreen extends StatelessWidget {
  const ReturnToScannerQrWidgetOnCryptoListScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: ()async{
          context.read<QrControllers>().openQRScanner(context);
        },
        icon: const Icon(Icons.reset_tv_rounded, size: 24),
        label: const Text(
          'Volver al escáner QR',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
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
