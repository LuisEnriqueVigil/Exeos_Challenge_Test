import 'package:exeos_network_challenge/src/domain/controllers/coins/coins_controller.dart';
import 'package:exeos_network_challenge/src/domain/routes/routes_string.dart';
import 'package:exeos_network_challenge/src/presentation/qr/screen/animation_crentral_of_screen_widget_loading_qr_scanner_screen.dart';
import 'package:exeos_network_challenge/src/presentation/qr/widgets/animate_text_search_widget_loading_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class LoadingQrScannerScreen extends StatefulWidget {
  final String? searchQuery;
  final VoidCallback? onCancel;
  final Future<dynamic> searchFunction; // Función de búsqueda real

  const LoadingQrScannerScreen({
    super.key,
    this.searchQuery,
    this.onCancel,
    required this.searchFunction,
  });

  @override
  State<LoadingQrScannerScreen> createState() => _LoadingQrScannerScreenState();
}

class _LoadingQrScannerScreenState extends State<LoadingQrScannerScreen>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;

  late Animation<double> _bounceAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _performRealSearch(); // Realizar búsqueda real
  }

  void _initializeAnimations() {
    // Animación de rebote de la moneda (arriba-abajo)
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(
      begin: -20.0,
      end: 20.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));

    // Animación de rotación de la moneda
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    // Animación de pulso para el círculo de fondo
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Animación de fade para el texto
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    // Repetir animaciones infinitamente
    _bounceController.repeat(reverse: true);
    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
    _fadeController.repeat(reverse: true);
  }

  // Realizar búsqueda real usando la función proporcionada
  Future<void> _performRealSearch() async {

    try {
      // Realizar la búsqueda real - el tiempo que tome será el real del API
      
      CoinsController coinsController = Provider.of<CoinsController>(context,listen: false);
      coinsController.allCryptos = await widget.searchFunction;
      
      // Retornar a la pantalla anterior con el resultado real
      if (mounted) {
        Navigator.pushNamed(
          context,
          RoutesName.cryptoListScreen, 
        );
      }
    } catch (e) {
      // En caso de error, retornar con información del error
      if (mounted) {
        Navigator.pushNamed(
          context,
          RoutesName.cryptoListScreen, 
        );
      }
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // Fondo con gradiente sutil
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.primary.withAlpha(40),
                    theme.colorScheme.surface,
                    theme.colorScheme.secondary.withAlpha(40),
                  ],
                ),
              ),
            ),

            // Contenido principal
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Título animado
                  AnimateTextSearchingWidgetLoadingQrScannerScreen(fadeAnimation: _fadeAnimation, theme: theme),

                  const SizedBox(height: 40),

                  // Área de animación principal
                  AnimationCentralOfScreenWidgetLoadingQrScannerScreen(
                    pulseAnimation: _pulseAnimation, 
                    theme: theme, 
                    bounceAnimation: _bounceAnimation, 
                    rotationAnimation: _rotationAnimation, 
                    rotationController: _rotationController
                  ),

                  const SizedBox(height: 40),

                  // Texto de búsqueda
                  if (widget.searchQuery != null)
                    AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeAnimation.value * 0.8,
                          child: Column(
                            children: [
                              Text(
                                'Buscando:',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withAlpha(40),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceVariant.withAlpha(40),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: theme.colorScheme.outline.withAlpha(40),
                                  ),
                                ),
                                child: Text(
                                  widget.searchQuery!,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 60),

                  // Indicador de progreso personalizado
                  SizedBox(
                    width: size.width * 0.6,
                    child: AnimatedBuilder(
                      animation: _rotationController,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          backgroundColor: theme.colorScheme.outline.withAlpha(40),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.primary,
                          ),
                          value: (_rotationController.value * 0.7) % 1.0,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Texto descriptivo
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value * 0.7,
                        child: Text(
                          'Esto puede tomar unos segundos...',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(40),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Botón de cancelar (opcional)
            if (widget.onCancel != null)
              Positioned(
                top: 16,
                right: 16,
                child: AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: IconButton(
                        onPressed: widget.onCancel,
                        icon: Icon(
                          Icons.close,
                          color: theme.colorScheme.onSurface.withAlpha(40),
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: theme.colorScheme.surface.withAlpha(40),
                          foregroundColor: theme.colorScheme.onSurface,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
