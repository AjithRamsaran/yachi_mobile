import '../../domain/entities/cart_item.dart';
import '../../../products/data/models/product_model.dart';

class CartItemModel {
  CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.name,
  });

  final int id;
  final ProductModel product;
  final int quantity;
  final String name;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': (product as ProductModel).toJson(),
      'quantity': quantity,
      'name': name,
    };
  }

}