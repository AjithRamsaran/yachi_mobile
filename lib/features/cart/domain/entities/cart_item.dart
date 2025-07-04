import 'package:equatable/equatable.dart';
import '../../../products/domain/entities/product.dart';

class CartItem extends Equatable {
  final int id;
  final Product product;
  final int quantity;
  final String name;

   CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.name,
  });

  double get totalPrice => product.price * quantity;

  @override
  List<Object?> get props => [id, product, quantity, name];
}