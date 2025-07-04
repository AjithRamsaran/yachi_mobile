import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final String category;
  final String subcategory;
  final String brand;
  final String productType;
  final Map<String, dynamic> productInfo;
  final List<String> platforms;
  final int stockQuantity;
  final bool isAvailable;
  final List<String> images;
  final String thumbnail;
  final List<String> tags;
  final String sku;
  final double rating;
  final int reviewCount;
  final String createdAt;
  final String? updatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.category,
    required this.subcategory,
    required this.brand,
    required this.productType,
    required this.productInfo,
    required this.platforms,
    required this.stockQuantity,
    required this.isAvailable,
    required this.images,
    required this.thumbnail,
    required this.tags,
    required this.sku,
    required this.rating,
    required this.reviewCount,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id, name, description, price, originalPrice, category, subcategory,
    brand, productType, productInfo, platforms, stockQuantity, isAvailable,
    images, thumbnail, tags, sku, rating, reviewCount, createdAt, updatedAt,
  ];
}

class ProductInfo extends Equatable {
  final String coverage;
  final String finish;
  final String spf;
  final String skinType;
  final List<String> shadesAvailable;
  final String volume;

  const ProductInfo({
    required this.coverage,
    required this.finish,
    required this.spf,
    required this.skinType,
    required this.shadesAvailable,
    required this.volume,
  });

  @override
  List<Object> get props => [coverage, finish, spf, skinType, shadesAvailable, volume];
}