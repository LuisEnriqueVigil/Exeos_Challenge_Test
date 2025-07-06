import 'package:flutter/material.dart';
import 'dart:math' as math;

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
    if (widget.searchQuery == null) {
      // Si no hay función de búsqueda, retornar error
      if (mounted) {
        Navigator.pop(context, {
          'success': false,
          'error': 'No se proporcionó función de búsqueda',
          'query': widget.searchQuery,
        });
      }
      return;
    }

    try {
      // Realizar la búsqueda real - el tiempo que tome será el real del API
      await widget.searchFunction;

      // Retornar a la pantalla anterior con el resultado real
      if (mounted) {
        Navigator.pop(context, {
          'success': true,
          'query': widget.searchQuery,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
      }
    } catch (e) {
      // En caso de error, retornar con información del error
      if (mounted) {
        Navigator.pop(context, {
          'success': false,
          'error': e.toString(),
          'query': widget.searchQuery,
        });
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
                    theme.colorScheme.primary.withOpacity(0.1),
                    theme.colorScheme.surface,
                    theme.colorScheme.secondary.withOpacity(0.05),
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
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Text(
                          'Buscando...',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Área de animación principal
                  SizedBox(
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
                                  color: theme.colorScheme.primary.withOpacity(0.1),
                                  border: Border.all(
                                    color: theme.colorScheme.primary.withOpacity(0.3),
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
                                        color: theme.colorScheme.primary.withOpacity(0.3),
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
                                    color: theme.colorScheme.primary.withOpacity(0.6),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ],
                    ),
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
                                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: theme.colorScheme.outline.withOpacity(0.3),
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
                          backgroundColor: theme.colorScheme.outline.withOpacity(0.2),
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
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
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
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: theme.colorScheme.surface.withOpacity(0.8),
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