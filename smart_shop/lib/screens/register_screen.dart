import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String confirmPassword = '';
  String username = '';

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isUsernameValid = false;
  bool _isEmailValid = false;
  bool _isPasswordLengthValid = false;
  bool _isPasswordUppercaseValid = false;
  bool _isPasswordLowercaseValid = false;
  bool _isPasswordDigitValid = false;
  bool _isPasswordMatch = false;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final Color cream = const Color(0xFFFAF3E0);
  final Color espresso = const Color(0xFF4E342E);
  final Color orange = const Color(0xFFF57C00);
  final Color beige = const Color(0xFFFFF8E1);
  final Color cocoa = const Color(0xFF3E2723);

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_validateUsername);
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validateConfirmPassword);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateUsername() {
    setState(() {
      username = _usernameController.text;
      _isUsernameValid = username.length >= 3;
    });
  }

  void _validateEmail() {
    setState(() {
      _isEmailValid = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_emailController.text);
    });
  }

  void _validatePassword() {
    setState(() {
      password = _passwordController.text;
      _isPasswordLengthValid = password.length >= 6;
      _isPasswordUppercaseValid = password.contains(RegExp(r'[A-Z]'));
      _isPasswordLowercaseValid = password.contains(RegExp(r'[a-z]'));
      _isPasswordDigitValid = password.contains(RegExp(r'[0-9]'));
      _isPasswordMatch = password == _confirmPasswordController.text;
    });
  }

  void _validateConfirmPassword() {
    setState(() {
      confirmPassword = _confirmPasswordController.text;
      _isPasswordMatch = password == confirmPassword;
    });
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account created! (Dummy only)')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        title: Text('Register', style: TextStyle(fontWeight: FontWeight.bold, color: espresso)),
        centerTitle: true,
        backgroundColor: cream,
        elevation: 0,
        iconTheme: IconThemeData(color: espresso),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create your account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: cocoa)),
              SizedBox(height: 30),
              _buildTextField(_usernameController, 'Username', Icons.person_outline, _isUsernameValid),
              SizedBox(height: 16),
              _buildTextField(_emailController, 'Email', Icons.mail_outline, _isEmailValid),
              SizedBox(height: 16),
              _buildPasswordField(_passwordController, 'Password', _obscurePassword, () => setState(() => _obscurePassword = !_obscurePassword)),
              SizedBox(height: 10),
              
              SizedBox(height: 16),
              _buildPasswordField(_confirmPasswordController, 'Confirm Password', _obscureConfirmPassword, () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword)),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(value: true, onChanged: (_) {}, activeColor: espresso),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: cocoa),
                        children: [
                          TextSpan(text: 'By signing up, you agree to our '),
                          TextSpan(text: 'Terms of service', style: TextStyle(fontWeight: FontWeight.bold, color: orange)),
                          TextSpan(text: ' and '),
                          TextSpan(text: 'Privacy policy', style: TextStyle(fontWeight: FontWeight.bold, color: orange)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Sign up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ', style: TextStyle(color: cocoa)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text('Login', style: TextStyle(fontWeight: FontWeight.bold, color: espresso)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, bool isValid) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: espresso),
        hintText: hint,
        filled: true,
        fillColor: beige,
        suffixIcon: controller.text.isNotEmpty
            ? Icon(isValid ? Icons.check_circle : Icons.cancel, color: isValid ? Colors.green : Colors.red)
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
      validator: (val) => val!.isEmpty ? 'Enter $hint' : null,
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hint, bool obscure, VoidCallback toggle) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock_outline, color: espresso),
        hintText: hint,
        filled: true,
        fillColor: beige,
        suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: espresso), onPressed: toggle),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
    );
  }

  Widget _buildValidationRow(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(isValid ? Icons.check_circle_outline : Icons.cancel_outlined, color: isValid ? Colors.green : Colors.grey, size: 18),
          SizedBox(width: 8),
          Text(text, style: TextStyle(color: isValid ? Colors.green : Colors.grey)),
        ],
      ),
    );
  }
}

