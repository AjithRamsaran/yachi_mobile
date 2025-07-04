import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../products/domain/entities/product.dart';
import '../repositories/cart_repository.dart';

class UpdateToCart {
  final CartRepository repository;

  UpdateToCart(this.repository);

  Future<Either<Failure, void>> call(int productId, int quantity, String name,Product product) async {
    return await repository.updateToCart(productId, quantity, name, product);
  }
}