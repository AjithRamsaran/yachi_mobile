import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item.dart';

abstract class CartState extends Equatable {
  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;

  CartLoaded({required this.items});

  double get totalAmount => items.fold(0, (sum, item) => sum + item.totalPrice);

  @override
  List<Object> get props => [items];
}

class CartError extends CartState {
  final String message;

  CartError({required this.message});

  @override
  List<Object> get props => [message];
}

class OrderPlaced extends CartState {}