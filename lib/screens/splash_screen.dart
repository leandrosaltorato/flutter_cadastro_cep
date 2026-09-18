import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _fadeIn;
  late final Animation<double> _scaleIn;
  late final Animation<double> _rotateIn;

  late final Animation<double> _fadeOut;
  late final Animation<double> _scaleOut;

  static const _duracaoEntrada = Duration(milliseconds: 1100);
  static const _duracaoExibicao = Duration(milliseconds: 1400);
  static const _duracaoSaida = Duration(milliseconds: 600);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: _duracaoEntrada);

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleIn = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _rotateIn = Tween<double>(begin: -0.15, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeOut = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scaleOut = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _executarSequencia();
  }

  Future<void> _executarSequencia() async {
    await _controller.forward();
    await Future.delayed(_duracaoExibicao);
    _controller.duration = _duracaoSaida;
    await _controller.reverse();

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => const HomeScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E7D32),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final indo = _controller.status != AnimationStatus.reverse;
            final opacidade = indo ? _fadeIn.value : _fadeOut.value;
            final escala = indo ? _scaleIn.value : _scaleOut.value;
            final rotacao = indo ? _rotateIn.value : 0.0;

            return Opacity(
              opacity: opacidade.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: escala,
                child: Transform.rotate(
                  angle: rotacao,
                  child: child,
                ),
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: ClipOval(
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.white,
                      child: const Icon(
                        Icons.people_alt_rounded,
                        color: Color(0xFF2E7D32),
                        size: 80,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Cadastro de Pessoas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
