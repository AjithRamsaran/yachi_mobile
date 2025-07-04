import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:yachii/features/products/presentation/productlist/widgets/product_card.dart';

import '../../domain/entities/product.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../product_details/bloc/products_event.dart';
import '../product_details/product_details_page.dart';
import 'bloc/products_bloc.dart';
import 'bloc/products_event.dart';
import 'bloc/products_state.dart';

typedef OnPressed = Function();

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductsBloc>().add(GetProductsEvent());
    context.read<CartBloc>().add(GetCartItemsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartPage()),
            ).then((value) {
              context.read<ProductsBloc>().add(GetProductsEvent());
            }),
          ),
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {

          if (state is ProductsInitial || state is ProductsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProductsLoaded) {
            return GridView.builder(
              key: ValueKey(state.products.length.toString()),
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                return ProductCard(
                    product: state.products[index],
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // builder: (context) => BlocProvider.value(
                          //   value: context.read<ProductsBloc>(),
                          //   child: ProductDetailsPage(productId: state.products[index].id),
                          // ),
                          builder: (context) => ProductDetailsPage(
                              productId: state.products[index].id),
                        ),
                      ).then((value) {
                        context.read<ProductsBloc>().add(GetProductsEvent());
                      });
                    });
              },
            );
          } else if (state is ProductsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(state.message),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<ProductsBloc>().add(GetProductsEvent()),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return Center(child: Text('Welcome to our store!'));
        },
      ),
    );
  }
}

