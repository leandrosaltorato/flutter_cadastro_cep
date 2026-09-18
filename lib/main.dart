import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const CadastroPessoasApp());
}

class CadastroPessoasApp extends StatelessWidget {
  const CadastroPessoasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Pessoas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
