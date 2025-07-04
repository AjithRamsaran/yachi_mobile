import 'package:equatable/equatable.dart';

import '../../../products/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCartItemsEvent extends CartEvent {
  final bool isFromUI;

  GetCartItemsEvent({this.isFromUI = true});
}

class AddToCartEvent extends CartEvent {
  final int productId;
  final int quantity;
  final String name;
  final Product product;

  AddToCartEvent({
    required this.productId,
    required this.quantity,
    required this.name,
    required this.product,
  });

  @override
  List<Object?> get props => [productId, quantity, name];
}

class UpdateToCartEvent extends CartEvent {
  final int productId;
  final int quantity;
  final String name;
  final Product product;

  UpdateToCartEvent(
      {required this.productId,
      required this.quantity,
      required this.name,
      required this.product});

  @override
  List<Object?> get props => [productId, quantity, name];
}

class RemoveFromCartEvent extends CartEvent {
  final int cartItemId;

  RemoveFromCartEvent({required this.cartItemId});

  @override
  List<Object> get props => [cartItemId];
}

class PlaceOrderEvent extends CartEvent {
  final List<CartItem> cartItems;
  final double totalPrice;

  PlaceOrderEvent({required this.cartItems, required this.totalPrice});
}

class CartUpdatedEvent extends CartEvent {
  final Map<String, dynamic> data;

  CartUpdatedEvent({required this.data});

  @override
  List<Object> get props => [data];
}
