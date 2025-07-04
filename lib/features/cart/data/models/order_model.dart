import 'package:yachii/features/cart/data/models/cart_item_model.dart';

import '../../domain/entities/cart_item.dart';
import '../../../products/data/models/product_model.dart';

class OrderModel {
  OrderModel(
      {required this.id, required this.cartItems, required this.totalPrice});

  final int id;
  final List<CartItemModel> cartItems;
  final double totalPrice;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
        id: json['id'],
        cartItems: (json['cart_items'] as List)
            .map((item) => CartItemModel.fromJson(item))
            .toList(),
        totalPrice: json['total_price']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cart_items': cartItems.map((item) => item.toJson()).toList(),
      'total_price': totalPrice
    };
  }
}
