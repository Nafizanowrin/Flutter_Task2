import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart'; 

class ApiService {
  final String _baseUrl = 'https://fakestoreapi.com'; 

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/products'));

      if (response.statusCode == 200) {
        final List<dynamic> productJson = json.decode(response.body);
        return productJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to API: $e');
    }
  }

  Future<List<String>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/products/categories'));

      if (response.statusCode == 200) {
        final List<dynamic> categoryJson = json.decode(response.body);
        return categoryJson.cast<String>();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to API: $e');
    }
  }
}