import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // ou Navigator

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(Duration(seconds: 2));

    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF42A5F5), // mesmo da splash nativa
      body: Center(child: Image.asset('assets/default/splash.png', width: 200)),
    );
  }
}
