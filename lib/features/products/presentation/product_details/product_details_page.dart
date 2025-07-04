import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/product.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../productlist/bloc/products_event.dart';
import 'bloc/product_bloc.dart';
import 'bloc/product_state.dart';
import 'bloc/products_event.dart';

class ProductDetailsPage extends StatefulWidget {
  final int productId;

  const ProductDetailsPage({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _quantity = 1;
  String name = "";
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(GetProductDetailsEvent(productId: widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartPage()),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProductDetailsLoaded) {
            return _buildProductDetails(state.product);
          } else if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(state.message),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ProductBloc>().add(
                      GetProductDetailsEvent(productId: widget.productId),
                    ),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildProductDetails(Product product) {
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  height: 300,
                  child: PageView.builder(
                    itemCount: product.images.length,
                    onPageChanged: (index) => setState(() => _currentImageIndex = index),
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: product.images[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.image_not_supported, size: 100),
                        ),
                      );
                    },
                  ),
                ),

                if (product.images.length > 1)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: product.images.asMap().entries.map((entry) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentImageIndex == entry.key
                                ? Colors.blue
                                : Colors.grey[300],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        product.brand,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),

                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: product.rating,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 20.0,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${product.rating} (${product.reviewCount} reviews)',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      Row(
                        children: [
                          Text(
                            currencyFormat.format(product.price),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            currencyFormat.format(product.originalPrice),
                            style: TextStyle(
                              fontSize: 18,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${((product.originalPrice - product.price) / product.originalPrice * 100).round()}% OFF',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        product.description,
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                      SizedBox(height: 16),

                      Text(
                        'Product Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      /*SizedBox(height: 8),
                      _buildProductInfoTile('Coverage', product.productInfo.coverage),
                      _buildProductInfoTile('Finish', product.productInfo.finish),
                      _buildProductInfoTile('SPF', product.productInfo.spf),
                      _buildProductInfoTile('Skin Type', product.productInfo.skinType),
                      _buildProductInfoTile('Volume', product.productInfo.volume),*/
                      SizedBox(height: 16),

                      /*if (product.productInfo.shadesAvailable.isNotEmpty) ...[
                        Text(
                          'Select Shade',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: product.productInfo.shadesAvailable.map((shade) {
                            return ChoiceChip(
                              label: Text(shade),
                              selected: _selectedShade == shade,
                              onSelected: (selected) {
                                setState(() => _selectedShade = selected ? shade : null);
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 16),
                      ],*/

                      Text(
                        'Quantity',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                            icon: Icon(Icons.remove),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _quantity.toString(),
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            onPressed: () => setState(() => _quantity++),
                            icon: Icon(Icons.add),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: product.isAvailable  ? () => _addToCart(context, product) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                product.isAvailable ? 'Add to Cart' : 'Out of Stock',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductInfoTile(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(': $value'),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context, Product product) {
   /* if (product.productInfo.shadesAvailable.isNotEmpty && _selectedShade == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a shade')),
      );
      return;
    }*/

    context.read<CartBloc>().add(AddToCartEvent(
      productId: product.id,
      quantity: _quantity,
      name: name,
      product: product
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added $_quantity item(s) to cart!')),
    );
  }
}