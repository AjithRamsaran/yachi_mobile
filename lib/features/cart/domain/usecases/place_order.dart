import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../products/domain/entities/product.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class PlaceOrder {
  final CartRepository repository;

  PlaceOrder(this.repository);

  Future<Either<Failure, void>> call(List<CartItem> cartItems, double totalPrice) async {
    return await repository.placeOrder(cartItems, totalPrice);
  }
}