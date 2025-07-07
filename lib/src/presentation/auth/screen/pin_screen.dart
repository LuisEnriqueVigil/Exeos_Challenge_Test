import 'package:exeos_network_challenge/src/domain/routes/routes_string.dart';
import 'package:exeos_network_challenge/src/presentation/auth/widgets/icon_principal_on_pin_screen.dart';
import 'package:exeos_network_challenge/src/presentation/auth/widgets/label_reference_access_account_on_pin_screen.dart';
import 'package:exeos_network_challenge/src/presentation/auth/widgets/pin_dots_on_pin_screen.dart';
import 'package:exeos_network_challenge/src/presentation/auth/widgets/text_reference_intent_write_on_pin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> with TickerProviderStateMixin {
  static const String _correctPin = '2345';
  static const int _maxAttempts = 3;
  
  String _currentPin = '';
  int _attempts = 0;
  bool _isLocked = false;
  bool _isLoading = false;
  
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  
  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onNumberPressed(String number) {
    if (_isLocked || _isLoading || _currentPin.length >= 4) return;
    
    HapticFeedback.lightImpact();
    setState(() {
      _currentPin += number;
    });
    
    if (_currentPin.length == 4) {
      _validatePin();
    }
  }

  void _onDeletePressed() {
    if (_isLocked || _isLoading || _currentPin.isEmpty) return;
    
    HapticFeedback.lightImpact();
    setState(() {
      _currentPin = _currentPin.substring(0, _currentPin.length - 1);
    });
  }

  void _validatePin() async {
    setState(() {
      _isLoading = true;
    });
    
    // Simular validación
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (_currentPin == _correctPin) {
      _onSuccess();
    } else {
      _onFailure();
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  void _onSuccess() {
    HapticFeedback.heavyImpact();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡PIN correcto! Acceso concedido'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
    
    // Aquí puedes navegar a la siguiente pantalla
    Navigator.pushReplacementNamed(context, RoutesName.qrScannerScreen);
  }

  void _onFailure() {
    HapticFeedback.heavyImpact();
    
    setState(() {
      _attempts++;
      _currentPin = '';
      
      if (_attempts >= _maxAttempts) {
        _isLocked = true;
      }
    });
    
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });
    
    if (_isLocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Máximo de intentos alcanzado. Acceso bloqueado.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PIN incorrecto. Intentos restantes: ${_maxAttempts - _attempts}'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _resetAttempts() {
    setState(() {
      _attempts = 0;
      _isLocked = false;
      _currentPin = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final EdgeInsets  padding = MediaQuery.of(context).padding;
    final double boxHeigthBig =size.height * 0.03;
    final double boxHeigthSmall = size.height * 0.01;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Verificación de PIN'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        
        automaticallyImplyLeading: false, //
        elevation: 0,
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: size.height - padding.top - kToolbarHeight - 40,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  
                  // Icono principal
                  IconPrincipalOnPinScreen(
                    isLocked: _isLocked
                  ),
                  
                  SizedBox(height: boxHeigthBig),
                  
                  // Título
                  LabelReferenceAccessAccountOnPinScreen(
                    isLocked: _isLocked
                  ),
                  
                  SizedBox(height: boxHeigthSmall),
                  
                  // Subtitle
                  TextReferenceIntentWriteOnPinScreen(isLocked: _isLocked),
                  
                   SizedBox(height: boxHeigthBig),
                  
                  // PIN Dots
                  PinDotsOnPinScreen(
                    shakeAnimation: _shakeAnimation, 
                    currentPin: _currentPin, 
                    isLocked: _isLocked
                  ),
                  
                   SizedBox(height: boxHeigthBig),
                  
                  // Contador de intentos
                  if (_attempts > 0 && !_isLocked)
                    Text(
                      'Intentos: $_attempts/$_maxAttempts',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  
                  SizedBox(height: boxHeigthSmall),
                  
                  // Teclado numérico
                  if (!_isLocked) ...[
                    _buildNumericKeypad(size: size),
                  ] else ...[
                    // Botón de reintentar cuando está bloqueado
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _resetAttempts,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumericKeypad({required Size size}) {
    return Column(
      children: [
        // Filas 1-3
        for (int row = 0; row < 3; row++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int col = 1; col <= 3; col++)
                  _buildKeypadButton(number:(row * 3 + col).toString(),size: size),
              ],
            ),
          ),
        
        // Fila del 0 y botón borrar
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: size.width*0.20), // Espacio vacío
              _buildKeypadButton(number:'0',size: size),
              _buildDeleteButton(size: size),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKeypadButton({required String number, required Size size}) {
    return GestureDetector(
      onTap: () => _onNumberPressed(number),
      child: Container(
        width: size.width * 0.18,
        height: size.width * 0.18,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: _isLoading && _currentPin.length == 4
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  number,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton({required Size size}) {
    return GestureDetector(
      onTap: _onDeletePressed,
      child: Container(
        width: size.width * 0.18,
        height: size.width * 0.18,
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.red[200]!),
        ),
        child: Icon(
          Icons.backspace_outlined,
          color: Colors.red[600],
          size: 24,
        ),
      ),
    );
  }
}


