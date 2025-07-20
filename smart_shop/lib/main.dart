import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/product_provider.dart';
import 'screens/register_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  runApp(MyApp(prefs: prefs));
}


class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  
  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => AuthProvider(prefs)),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider(prefs)),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
    return MaterialApp(
      title: 'Smart Shop',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.currentTheme,
      home: const SplashScreen(),
      routes: {
        '/register': (context) => RegisterScreen(),
      },
          );
        },
      ),
    );
  }
  
} 