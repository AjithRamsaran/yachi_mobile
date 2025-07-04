import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';

abstract class ProductState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}


class ProductDetailsLoaded extends ProductState {
  final Product product;

  ProductDetailsLoaded({required this.product});

  @override
  List<Object> get props => [product];
}

class ProductError extends ProductState {
  final String message;

  ProductError({required this.message});

  @override
  List<Object> get props => [message];
}