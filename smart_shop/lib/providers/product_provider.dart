import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';


enum SortType {
  none,
  priceLowToHigh,
  priceHighToLow,
  rating,
}

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String _error = '';
  String _selectedCategory = 'all';
  List<String> _categories = [];
  SortType _sortType = SortType.none; // New: Default sort type

  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get selectedCategory => _selectedCategory;
  List<String> get categories => _categories;
  SortType get sortType => _sortType; // New: Getter for sort type

  final ApiService _apiService = ApiService();

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      
      _products = await _apiService.fetchProducts();
     
      _applyFilterAndSearch();
      
      await fetchCategories();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load products: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCategories() async {
    try {
      
      _categories = await _apiService.fetchCategories();
      _categories.insert(0, 'all'); 
      notifyListeners();
    } catch (e) {
      print('Failed to load categories: $e');
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilterAndSearch();
    notifyListeners();
  }

  // New: Method to set sort type
  void setSortType(SortType type) {
    _sortType = type;
    _applyFilterAndSearch(); 
    notifyListeners();
  }

  void searchProducts(String query) {
    _applyFilterAndSearch(searchQuery: query);
    notifyListeners();
  }

  void _applyFilterAndSearch({String? searchQuery}) {
    List<Product> tempProducts = List.from(_products);

   
    if (_selectedCategory != 'all') {
      tempProducts = tempProducts
          .where((product) => product.category == _selectedCategory)
          .toList();
    }

    
    if (searchQuery != null && searchQuery.isNotEmpty) {
      tempProducts = tempProducts
          .where((product) =>
              product.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
              product.description.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    // 3. Apply sorting
    switch (_sortType) {
      case SortType.priceLowToHigh:
        tempProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortType.priceHighToLow:
        tempProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortType.rating:
        // Assuming your Product model has a 'rating' field (e.g., product.rating.rate)
        // Adjust this based on your actual Product model's rating structure
        tempProducts.sort((a, b) => b.rating.rate.compareTo(a.rating.rate));
        break;
      case SortType.none:
      default:
       
        break;
    }

    _filteredProducts = tempProducts;
  }
}