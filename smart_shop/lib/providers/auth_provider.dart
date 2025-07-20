import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userEmailKey = 'user_email';

  AuthProvider(this.prefs) {
    _loadAuthState();
  }

  bool _isLoggedIn = false;
  String _userEmail = '';

  bool get isLoggedIn => _isLoggedIn;
  String get userEmail => _userEmail;

  void _loadAuthState() {
    _isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    _userEmail = prefs.getString(_userEmailKey) ?? '';
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    
    if (email.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
      _userEmail = email;
      
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userEmailKey, email);
      
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _userEmail = '';
    
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.setString(_userEmailKey, '');
    
    notifyListeners();
  }
} 