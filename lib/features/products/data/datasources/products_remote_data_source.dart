import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import '../models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductDetails(int id);
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final Dio client;

  ProductsRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProducts() async {
    String url = "http://0.0.0.0:8000/api/v1/products/";
    print('http://0.0.0.0:8000/api/v1/products/');

    try {
      final Response response = await client.get(url);

      if (response.statusCode == 200) {

        final List<dynamic> responseData = response.data["products"];

        return responseData
            .map((productJson) => ProductModel.fromJson(productJson))
            .toList();
      } else {

        log('Error: API returned status code ${response.statusCode}');
        log('Response Body: ${response.data}');
        throw Exception();
      }
    } on DioException catch (e) {
      if (e.response != null) {
        log('Dio Error (Response): ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        log('Dio Error (No Response): ${e.message}');
      }
      throw Exception();
    } catch (e) {
      log('An unexpected error occurred: $e');
      throw Exception();
    }

    // try {
    //   final response = await client.get('http://0.0.0.0:8000/api/v1/products/');
    //   log(jsonDecode(response.data));
    //   return (jsonDecode(response.data) as List)
    //       .map((product) => ProductModel.fromJson(product))
    //       .toList();
    // } catch (e) {
    //   log(e.toString());
    //   return [];
    // }
  }

  @override
  Future<ProductModel> getProductDetails(int id) async {
    final response = await client.get('http://0.0.0.0:8000/api/v1/products/$id');
    return ProductModel.fromJson(response.data);
  }
}
