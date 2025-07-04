import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../products/domain/entities/product.dart';
import '../entities/cart_item.dart';
import 'package:yachii/features/cart/domain/entities/order.dart' as order;


abstract class CartRepository {
  Future<Either<Failure, List<CartItem>>> getCartItems();
  Future<Either<Failure, void>> addToCart(int productId, int quantity, String name,Product product);
  Future<Either<Failure, void>> updateToCart(int productId, int quantity, String name, Product product);
  Future<Either<Failure, void>> removeFromCart(int cartItemId);
  Future<Either<Failure, void>> placeOrder(List<CartItem> cartItems, double totalPrice);
  Future<Either<Failure, List<order.Order>>> getOrders();
}