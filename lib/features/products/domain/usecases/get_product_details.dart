import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/products_repository.dart';

class GetProductDetails {
  final ProductsRepository repository;

  GetProductDetails(this.repository);

  Future<Either<Failure, Product>> call(int id) async {
    return await repository.getProductDetails(id);
  }
}