import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:yachii/features/cart/presentation/pages/widgets/cart_item_card.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../../domain/entities/cart_item.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(GetCartItemsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is OrderPlaced) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Order placed successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return _buildEmptyCart();
            }
            return _buildCartItems(state);
          } else if (state is CartError) {
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
                        context.read<CartBloc>().add(GetCartItemsEvent()),
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

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add some products to get started',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems(CartLoaded state) {
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              return CartItemCard(
                item: state.items[index],
                onRemove: (itemId) {
                  context
                      .read<CartBloc>()
                      .add(RemoveFromCartEvent(cartItemId: itemId));
                },
              );
            },
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total (${state.items.length} items)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    currencyFormat.format(state.totalAmount),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _showOrderConfirmation(context, state),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Place Order',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showOrderConfirmation(BuildContext context, CartLoaded state) {
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order Summary:'),
              SizedBox(height: 8),
              ...state.items
                  .map((item) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${item.product.name} x${item.quantity}',
                                style: TextStyle(fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              currencyFormat.format(item.totalPrice),
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    currencyFormat.format(state.totalAmount),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<CartBloc>().add(PlaceOrderEvent(
                    cartItems: state.items, totalPrice: state.totalAmount));
              },
              child: Text('Confirm Order'),
            ),
          ],
        );
      },
    );
  }
}

