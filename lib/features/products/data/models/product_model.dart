import '../../domain/entities/product.dart';

class ProductModel {


  const ProductModel({
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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
/*

   print("id: ${json['id']}");

   print(json['description']);
     print( json['price'].toDouble());
    print( json['original_price'].toDouble());
    print( json['category']);
    print( json['subcategory']);
    print( json['brand']);
    print( json['product_type']);
    print(json['product_info']);
    print( List<String>.from(json['platforms']));
    print( json['stock_quantity']);
    print( json['is_available']);
    print( List<String>.from(json['images']));
    print( json['thumbnail']);
    print( List<String>.from(json['tags']));
    print(json['sku']);
    print( json['rating'].toDouble());
    print( json['review_count']);
    print( json['created_at']);
    print( json['updated_at']);
*/

    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      originalPrice: json['original_price'].toDouble(),
      category: json['category'],
      subcategory: json['subcategory'],
      brand: json['brand'],
      productType: json['product_type'],
      productInfo: json['product_info'], //ProductInfoModel.fromJson(json['product_info']),
      platforms: List<String>.from(json['platforms']),
      stockQuantity: json['stock_quantity'],
      isAvailable: json['is_available'],
      images: List<String>.from(json['images']).map((e) => "https://picsum.photos/seed/picsum/200/300") .toList(),//List<String>.from(json['images']),
      thumbnail: "https://picsum.photos/seed/picsum/200/300", //json['thumbnail'],
      tags: List<String>.from(json['tags']),
      sku: json['sku'],
      rating: json['rating'].toDouble(),
      reviewCount: json['review_count'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'original_price': originalPrice,
      'category': category,
      'subcategory': subcategory,
      'brand': brand,
      'product_type': productType,
      'product_info': productInfo,
      'platforms': platforms,
      'stock_quantity': stockQuantity,
      'is_available': isAvailable,
      'images': images,
      'thumbnail': thumbnail,
      'tags': tags,
      'sku': sku,
      'rating': rating,
      'review_count': reviewCount,
      'created_at': createdAt,
      'updated_at': updatedAt ?? "",
    };
  }

}



/*
class ProductInfoModel extends ProductInfo {
  const ProductInfoModel({
    required super.coverage,
    required super.finish,
    required super.spf,
    required super.skinType,
    required super.shadesAvailable,
    required super.volume,
  });

  factory ProductInfoModel.fromJson(Map<String, dynamic> json) {
    return ProductInfoModel(
      coverage: json['coverage'],
      finish: json['finish'],
      spf: json['spf'],
      skinType: json['skin_type'],
      shadesAvailable: List<String>.from(json['shades_available']),
      volume: json['volume'],
    );
  }
}
*/
