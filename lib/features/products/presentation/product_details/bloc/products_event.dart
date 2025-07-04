import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class GetProductDetailsEvent extends ProductEvent {
  final int productId;

  GetProductDetailsEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}
