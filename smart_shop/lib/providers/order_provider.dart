import 'package:flutter/material.dart';
import 'package:smart_shop/models/order.dart';
import 'package:smart_shop/models/cart_item.dart'; 

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0, 
      Order(
        id: DateTime.now().toString(),
        amount: total,
        products: cartProducts.toList(), // Create a copy to avoid reference issues
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }
}