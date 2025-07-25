import 'package:flutter/foundation.dart';
import 'package:smart_shop/models/cart_item.dart'; 

class Order {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  Order({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}