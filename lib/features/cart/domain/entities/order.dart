import 'package:equatable/equatable.dart';

import 'cart_item.dart';

class Order extends Equatable {
  List<CartItem> cartItems;
  double totalPrice;
  int orderId;

  Order(
      {required this.orderId,
      required this.cartItems,
      required this.totalPrice});

  @override
  List<Object> get props => [orderId];
}
