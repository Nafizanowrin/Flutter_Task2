import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'package:smart_shop/screens/home_screen.dart'; 


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _fadeController;

  late Animation<double> _logoScale;
  late Animation<double> _textFade;
  late Animation<double> _progressValue;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _progressValue = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    _fadeController.forward();
    await Future.delayed(const Duration(seconds: 3));
    _navigateNext();
  }

  void _navigateNext() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final nextPage = authProvider.isLoggedIn ? const HomeScreen() : const LoginScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (_, animation, __) =>
            FadeTransition(opacity: animation, child: nextPage),
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFFAF3E0), // Light Cream
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _logoScale,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF57C00).withOpacity(0.2), // Burnt Orange tint
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4E342E).withOpacity(0.2), // Espresso Brown shadow
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shopping_cart,
                    size: 80,
                    color: Color(0xFF4E342E), // Espresso Brown
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FadeTransition(
                opacity: _textFade,
                child: Column(
                  children: const [
                    Text(
                      'Smart Shop',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3E2723), // Deep Cocoa
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '-makes you beautiful-',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4E342E), 
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: AnimatedBuilder(
                  animation: _progressValue,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _progressValue.value,
                      minHeight: 4,
                      backgroundColor: const Color(0xFFF57C00).withOpacity(0.15),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4E342E)),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              FadeTransition(
                opacity: _textFade,
                child: const Text(
                  'Loading...'
                  ,
                  style: TextStyle(
                    color: Color(0xFF4E342E),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
