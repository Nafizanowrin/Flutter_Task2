import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'register_screen.dart'; 


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isRegisterMode = false;
  bool _isPasswordVisible = false;

  late AnimationController _animationController;
  late AnimationController _logoAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  final Color lightCream = Color(0xFFFAF3E0);
  final Color espressoBrown = Color(0xFF4E342E);
  final Color burntOrange = Color(0xFFF57C00);
  final Color beigeTint = Color(0xFFFFF8E1);
  final Color deepCocoa = Color(0xFF3E2723);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _logoAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _logoAnimationController, curve: Curves.elasticOut),
    );

    _logoAnimationController.forward();
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    _logoAnimationController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid credentials. Please try again.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightCream,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: AnimatedBuilder(
                      animation: _logoAnimationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: beigeTint,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.shopping_cart,
                                  size: 80,
                                  color: burntOrange,
                                ),
                              ),
                              SizedBox(height: 24),
                              Text(
                                'Smart Shop',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: deepCocoa,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '-makes you beautiful-',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: espressoBrown,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Container(
                              decoration: BoxDecoration(
                                color: beigeTint,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                              ),
                              padding: EdgeInsets.all(32),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      _isRegisterMode ? 'Create Account' : 'Welcome Back',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: deepCocoa,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 16),
                                    _buildTextField(
                                      controller: _emailController,
                                      label: 'Email',
                                      icon: Icons.email,
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    SizedBox(height: 16),
                                    _buildTextField(
                                      controller: _passwordController,
                                      label: 'Password',
                                      icon: Icons.lock,
                                      obscureText: !_isPasswordVisible,
                                      suffixIcon: IconButton(
                                        icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                                        onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                                      ),
                                    ),
                                    SizedBox(height: 24),
                                    ElevatedButton(
                                      onPressed: _isLoading ? null : _submitForm,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: burntOrange,
                                        padding: EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: _isLoading
                                          ? CircularProgressIndicator(color: Colors.white)
                                          : Text(
                                              _isRegisterMode ? 'Create Account' : 'Sign In',
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                    ),
                                    TextButton(
  onPressed: () {
    Navigator.pushNamed(context, '/register');
  },
  child: Text(
    'Don\'t have an account? Create One',
    style: TextStyle(color: espressoBrown),
  ),
),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: espressoBrown),
        suffixIcon: suffixIcon,
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: espressoBrown.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: espressoBrown, width: 2),
        ),
      ),
    );
  }
}
