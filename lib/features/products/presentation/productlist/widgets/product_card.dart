import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../../cart/presentation/bloc/cart_event.dart';
import '../../../domain/entities/product.dart';
import '../products_page.dart';

class ProductCard extends StatelessWidget {
  final OnPressed onPressed;

  final Product product;

  const ProductCard({Key? key, required this.product, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => onPressed.call(),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: product.thumbnail,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: product.rating,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 12.0,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '(${product.reviewCount})',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          currencyFormat.format(product.price),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          currencyFormat.format(product.originalPrice),
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    SizedBox(
                      width: double.infinity,
                      height: 28,
                      child: ElevatedButton(
                        onPressed: () => _addToCart(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child:
                        Text('Add to Cart', style: TextStyle(fontSize: 10)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(BuildContext context) {
    context.read<CartBloc>().add(
        AddToCartEvent(productId: product.id, quantity: 1, name: product.name, product: product));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added to cart!')),
    );
  }
}
