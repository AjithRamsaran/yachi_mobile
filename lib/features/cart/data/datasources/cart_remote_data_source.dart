import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:yachii/features/cart/data/models/order_model.dart';
import 'package:yachii/features/products/data/models/product_model.dart';
import '../models/cart_item_model.dart';

abstract class CartRemoteDataSource {
  Future<List<CartItemModel>> getCartItems();

  Future<void> addToCart(int productId, int quantity, String name,
      ProductModel product);

  Future<void> updateToCart(int productId, int quantity, String name,
      ProductModel product);

  Future<void> removeFromCart(int cartItemId);

  Future<void> placeOrder(List<CartItemModel> cartItems, double totalPrice);

  Future<List<OrderModel>> getOrders();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final Dio client;

  CartRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CartItemModel>> getCartItems() async {
    final response = await client.get('/cart/items');
    return (response.data["items"] as List)
        .map((item) => CartItemModel.fromJson(item))
        .toList();
  }

  @override
  Future<void> addToCart(int productId, int quantity, String name,
      ProductModel product) async {
    var body = {
      'id': productId,
      'quantity': quantity,
      'name': name,
      'product': product.toJson()
    };
    log("Add to Cart: $body");
    var response = await client.post('cart/items', data: {
      'id': productId,
      'quantity': quantity,
      'product': product.toJson(),
      'name': name
    });
    print(response.statusCode);
  }

  @override
  Future<void> updateToCart(int productId, int quantity, String name,
      ProductModel product) async {
    var body = {
      'id': productId,
      'quantity': quantity,
      'name': name,
      'product': product.toJson(),
    };

    try {
      await client.put('cart/items/$productId', data: {
        'id': productId,
        'quantity': quantity,
        'name': name,
        'product': product.toJson(),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> removeFromCart(int cartItemId) async {
    await client.delete('cart/items/$cartItemId');
  }

  @override
  Future<void> placeOrder(List<CartItemModel> cartItems,
      double totalPrice) async {
    var body = {
      'id' : 0,
      'total_price': totalPrice,
      'items': cartItems.map((cartItem) => cartItem.toJson()).toList(),
    };
    log('Place Order ${jsonEncode(body)}');
    await client.post('cart/placeorder', data: body);
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    final response = await client.get('/cart/items');
    return (response.data["items"] as List)
        .map((item) => OrderModel.fromJson(item))
        .toList();
  }

}
