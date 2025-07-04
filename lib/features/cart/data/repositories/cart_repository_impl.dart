import 'package:dartz/dartz.dart';
import 'package:yachii/features/cart/domain/entities/order.dart';
import 'package:yachii/features/products/data/models/product_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_data_source.dart';
import '../models/cart_item_model.dart';
import 'package:yachii/features/cart/domain/entities/order.dart' as order;

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CartRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CartItem>>> getCartItems() async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.getCartItems();
        List<CartItem> cartItems = items.map((item) => CartItem(id: item.id, product: Product(id: item.product.id, name: item.product.name, description: item.product.description, price: item.product.price, originalPrice: item.product.originalPrice, category: item.product.category, subcategory: item.product.subcategory, brand: item.product.brand, productType: item.product.productType, productInfo: item.product.productInfo, platforms: item.product.platforms, stockQuantity: item.product.stockQuantity, isAvailable: item.product.isAvailable, images: item.product.images, thumbnail: item.product.thumbnail, tags: item.product.tags, sku: item.product.sku, rating: item.product.rating, reviewCount: item.product.reviewCount, createdAt: item.product.createdAt), quantity: item.quantity, name: item.name)).toList();
        return Right(cartItems);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(
      int productId, int quantity, String name, Product product) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addToCart(
            productId,
            quantity,
            name,
            ProductModel(
                id: product.id,
                name: product.name,
                description: product.description,
                price: product.price,
                originalPrice: product.originalPrice,
                category: product.category,
                subcategory: product.subcategory,
                brand: product.brand,
                productType: product.productType,
                productInfo: product.productInfo,
                platforms: product.platforms,
                stockQuantity: product.stockQuantity,
                isAvailable: product.isAvailable,
                images: product.images,
                thumbnail: product.thumbnail,
                tags: product.tags,
                sku: product.sku,
                rating: product.rating,
                reviewCount: product.reviewCount,
                createdAt: product.createdAt));
        return Right(null);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateToCart(
      int productId, int quantity, String name, Product product) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateToCart(
            productId,
            quantity,
            name,
            ProductModel(
                id: product.id,
                name: product.name,
                description: product.description,
                price: product.price,
                originalPrice: product.originalPrice,
                category: product.category,
                subcategory: product.subcategory,
                brand: product.brand,
                productType: product.productType,
                productInfo: product.productInfo,
                platforms: product.platforms,
                stockQuantity: product.stockQuantity,
                isAvailable: product.isAvailable,
                images: product.images,
                thumbnail: product.thumbnail,
                tags: product.tags,
                sku: product.sku,
                rating: product.rating,
                reviewCount: product.reviewCount,
                createdAt: product.createdAt));
        return Right(null);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(int cartItemId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.removeFromCart(cartItemId);
        return Right(null);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> placeOrder(
      List<CartItem> cartItems, double totalPrice) async {
    if (await networkInfo.isConnected) {
      try {
        List<CartItemModel> cartItemModelList = cartItems
            .map((item) => CartItemModel(quantity: item.quantity, name: item.name, product: ProductModel(id: item.product.id, name: item.product.name, description: item.product.description, price: item.product.price, originalPrice: item.product.originalPrice, category: item.product.category, subcategory: item.product.subcategory, brand: item.product.brand, productType: item.product.productType, productInfo: item.product.productInfo, platforms: item.product.platforms, stockQuantity: item.product.stockQuantity, isAvailable: item.product.isAvailable, images: item.product.images, thumbnail: item.product.thumbnail, tags: item.product.tags, sku: item.product.sku, rating: item.product.rating, reviewCount: item.product.reviewCount, createdAt: item.product.createdAt), id: item.id))
            .toList();
        await remoteDataSource.placeOrder(cartItemModelList, totalPrice);
        return Right(null);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<order.Order>>> getOrders() async {
    if (await networkInfo.isConnected) {
      try {
        final orders = await remoteDataSource.getOrders();
        List<order.Order> orderList = orders.map((element) => order.Order(orderId: element.id, cartItems: element.cartItems.map((item) => CartItem(id: item.id, product: Product(id: item.product.id, name: item.product.name, description: item.product.description, price: item.product.price, originalPrice: item.product.originalPrice, category: item.product.category, subcategory: item.product.subcategory, brand: item.product.brand, productType: item.product.productType, productInfo: item.product.productInfo, platforms: item.product.platforms, stockQuantity: item.product.stockQuantity, isAvailable: item.product.isAvailable, images: item.product.images, thumbnail: item.product.thumbnail, tags: item.product.tags, sku: item.product.sku, rating: item.product.rating, reviewCount: item.product.reviewCount, createdAt: item.product.createdAt), quantity: item.quantity, name: item.name)).toList(), totalPrice: element.totalPrice)).toList();

        return Right(orderList);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
