import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_product_details.dart';
import '../../../domain/usecases/get_products.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProducts getProducts;

  ProductsBloc({
    required this.getProducts,
  }) : super(ProductsInitial()) {
    on<GetProductsEvent>(_onGetProducts);
  }

  void _onGetProducts(GetProductsEvent event, Emitter<ProductsState> emit) async {
    emit(ProductsLoading());
    final result = await getProducts();
    result.fold(
          (failure) => emit(ProductsError(message: 'Failed to load products')),
          (products) => emit(ProductsLoaded(products: products)),
    );
  }

}
