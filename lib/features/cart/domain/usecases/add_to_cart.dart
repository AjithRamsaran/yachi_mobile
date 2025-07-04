import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../products/domain/entities/product.dart';
import '../repositories/cart_repository.dart';

class AddToCart {
  final CartRepository repository;

  AddToCart(this.repository);

  Future<Either<Failure, void>> call(int productId, int quantity, String name , Product product) async {
    return await repository.addToCart(productId, quantity, name, product);
  }
}