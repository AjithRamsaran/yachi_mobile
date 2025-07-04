import 'package:equatable/equatable.dart';

import '../../../domain/entities/product.dart';

abstract class ProductsState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;

  ProductsLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class ProductDetailsLoaded extends ProductsState {
  final Product product;

  ProductDetailsLoaded({required this.product});

  @override
  List<Object> get props => [product];
}

class ProductsError extends ProductsState {
  final String message;

  ProductsError({required this.message});

  @override
  List<Object> get props => [message];
}