import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_remote_data_source.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getProducts();

        final productList = products.map((product) => Product(id: product.id, name: product.name, description: product.description, price: product.price, originalPrice: product.originalPrice, category: product.category, subcategory: product.subcategory, brand: product.brand, productType: product.productType, productInfo: product.productInfo, platforms: product.platforms, stockQuantity: product.stockQuantity, isAvailable: product.isAvailable, images: product.images, thumbnail: product.thumbnail, tags: product.tags, sku: product.sku, rating: product.rating, reviewCount: product.reviewCount, createdAt: product.createdAt)).toList();

        return Right(productList);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> getProductDetails(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final product = await remoteDataSource.getProductDetails(id);
        return Right(Product(id: product.id, name: product.name, description: product.description, price: product.price, originalPrice: product.originalPrice, category: product.category, subcategory: product.subcategory, brand: product.brand, productType: product.productType, productInfo: product.productInfo, platforms: product.platforms, stockQuantity: product.stockQuantity, isAvailable: product.isAvailable, images: product.images, thumbnail: product.thumbnail, tags: product.tags, sku: product.sku, rating: product.rating, reviewCount: product.reviewCount, createdAt: product.createdAt));
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
