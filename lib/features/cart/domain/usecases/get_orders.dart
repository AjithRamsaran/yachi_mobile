import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';
import 'package:yachii/features/cart/domain/entities/order.dart' as order;

class GetOrders {
  final CartRepository repository;

  GetOrders(this.repository);

  Future<Either<Failure, List<order.Order>>> call() async {
    return await repository.getOrders();
  }
}