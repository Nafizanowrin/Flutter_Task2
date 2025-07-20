import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8F2),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFF3E0),
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.brown[800]),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildProfileHeader(context, auth),
                SizedBox(height: 24),
                _buildStatsSection(context),
                SizedBox(height: 24),
                _buildSettingsSection(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, AuthProvider auth) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.brown[300],
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              auth.userEmail.isNotEmpty ? auth.userEmail : 'Guest User',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Smart Shop Customer',
              style: TextStyle(color: Colors.brown[200], fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      return _buildStatItem(
                        context,
                        'Cart Items',
                        '${cart.itemCount}',
                        Icons.shopping_cart,
                        Colors.brown,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Consumer<FavoritesProvider>(
                    builder: (context, favorites, child) {
                      return _buildStatItem(
                        context,
                        'Favorites',
                        '${favorites.favorites.length}',
                        Icons.favorite,
                        Colors.redAccent,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
          Text(
            title,
            style: TextStyle(color: Colors.brown[300], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: Colors.brown,
                );
              },
            ),
            title: Text('Theme'),
            subtitle: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Text(themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode');
              },
            ),
            trailing: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) => themeProvider.toggleTheme(),
                );
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shopping_cart, color: Colors.brown),
            title: Text('Clear Cart'),
            subtitle: Text('Remove all items from cart'),
            onTap: () {
              _confirmClear(
                context,
                title: 'Clear Cart',
                message: 'Are you sure you want to clear your cart?',
                onConfirm: () {
                  Provider.of<CartProvider>(context, listen: false).clear();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cart cleared')),
                  );
                },
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.redAccent),
            title: Text('Clear Favorites'),
            subtitle: Text('Remove all favorite items'),
            onTap: () {
              _confirmClear(
                context,
                title: 'Clear Favorites',
                message: 'Are you sure you want to clear your favorites?',
                onConfirm: () {
                  Provider.of<FavoritesProvider>(context, listen: false).clearFavorites();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Favorites cleared')),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _confirmClear(BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: onConfirm,
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }
}
