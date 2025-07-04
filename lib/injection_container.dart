import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'core/constants.dart';
import 'features/cart/domain/usecases/get_orders.dart';
import 'features/cart/domain/usecases/update_to_cart.dart';
import 'features/products/data/datasources/products_remote_data_source.dart';
import 'features/products/data/repositories/products_repository_impl.dart';
import 'features/products/domain/repositories/products_repository.dart';
import 'features/products/domain/usecases/get_products.dart';
import 'features/products/domain/usecases/get_product_details.dart';

import 'features/cart/data/datasources/cart_remote_data_source.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/cart/domain/repositories/cart_repository.dart';
import 'features/cart/domain/usecases/add_to_cart.dart';
import 'features/cart/domain/usecases/get_cart_items.dart';
import 'features/cart/domain/usecases/remove_from_cart.dart';
import 'features/cart/domain/usecases/place_order.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';

import 'core/network/network_info.dart';
import 'core/websocket/websocket_service.dart';
import 'features/products/presentation/product_details/bloc/product_bloc.dart';
import 'features/products/presentation/productlist/bloc/products_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Products
  sl.registerLazySingleton(() => ProductsBloc(getProducts: sl()));
  sl.registerLazySingleton(() => ProductBloc(getProductDetails: sl()));

  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetProductDetails(sl()));
  sl.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<ProductsRemoteDataSource>(
    () => ProductsRemoteDataSourceImpl(client: sl()),
  );

  // Features - Cart
  sl.registerLazySingleton(() => CartBloc(
      addToCart: sl(),
      updateToCart: sl(),
      getCartItems: sl(),
      removeFromCart: sl(),
      placeOrder: sl(),
      webSocketService: sl(),
      getOrders: sl()));
  sl.registerLazySingleton(() => AddToCart(sl()));
  sl.registerLazySingleton(() => UpdateToCart(sl()));
  sl.registerLazySingleton(() => GetCartItems(sl()));
  sl.registerLazySingleton(() => RemoveFromCart(sl()));
  sl.registerLazySingleton(() => PlaceOrder(sl()));
  sl.registerLazySingleton(() => GetOrders(sl()));
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(client: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton<WebSocketService>(() => WebSocketServiceImpl());

  // External
  sl.registerLazySingleton(() => Dio(BaseOptions(baseUrl: BASE_URL)));
}
