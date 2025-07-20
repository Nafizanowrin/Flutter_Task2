import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product.dart';
import '../widgets/trending_card.dart';

class FavoritesProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  static const String _favoritesKey = 'favorites';

  FavoritesProvider(this.prefs) {
    _loadFavorites();
  }

  final Set<int> _favoriteIds = {};
  final List<Product> _favorites = [];

  Set<int> get favoriteIds => {..._favoriteIds};
  List<Product> get favorites => [..._favorites];

  void _loadFavorites() {
    final String? favoritesJson = prefs.getString(_favoritesKey);
    if (favoritesJson != null) {
      final List<dynamic> favoritesList = json.decode(favoritesJson);
      _favoriteIds.clear();
      _favorites.clear();
      
      for (var item in favoritesList) {
        _favoriteIds.add(item['id']);
        _favorites.add(Product.fromJson(item));
      }
    }
    notifyListeners();
  }

  void _saveFavorites() {
    final List<Map<String, dynamic>> favoritesList = 
        _favorites.map((product) => product.toJson()).toList();
    prefs.setString(_favoritesKey, json.encode(favoritesList));
  }

  bool isFavorite(int productId) {
    return _favoriteIds.contains(productId);
  }

  void toggleFavorite(Product product) {
    if (_favoriteIds.contains(product.id)) {
      _favoriteIds.remove(product.id);
      _favorites.removeWhere((p) => p.id == product.id);
    } else {
      _favoriteIds.add(product.id);
      _favorites.add(product);
    }
    _saveFavorites();
    notifyListeners();
  }

  void removeFavorite(int productId) {
    _favoriteIds.remove(productId);
    _favorites.removeWhere((p) => p.id == productId);
    _saveFavorites();
    notifyListeners();
  }

  void clearFavorites() {
    _favoriteIds.clear();
    _favorites.clear();
    _saveFavorites();
    notifyListeners();
  }
}