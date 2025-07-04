import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_product_details.dart';
import 'products_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductDetails getProductDetails;

  ProductBloc({
    required this.getProductDetails,
  }) : super(ProductInitial()) {
    on<GetProductDetailsEvent>(_onGetProductDetails);
  }


  void _onGetProductDetails(GetProductDetailsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await getProductDetails(event.productId);
    result.fold(
          (failure) => emit(ProductError(message: 'Failed to load product details')),
          (product) => emit(ProductDetailsLoaded(product: product)),
    );
  }
}
