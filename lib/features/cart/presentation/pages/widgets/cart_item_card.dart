import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/cart_item.dart';
import '../../bloc/cart_bloc.dart';
import '../../bloc/cart_event.dart';

class CartItemCard extends StatefulWidget {
  final CartItem item;
  final Function(int) onRemove;

  const CartItemCard({
    Key? key,
    required this.item,
    required this.onRemove,
  }) : super(key: key);

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Card(
        key: ValueKey(widget.item.product.id.toString()),
        margin: EdgeInsets.only(bottom: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: widget.item.product.thumbnail,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.product.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.item.product.brand,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        if (widget.item.name != null) ...[
                          SizedBox(height: 4),
                          Text(
                            'Name: ${widget.item.name}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                        SizedBox(height: 8)
                      ])),
              Row(
                children: [
                  IconButton(
                    onPressed: widget.item.quantity > 1
                        ? () {
                      //setState(() => widget.item.quantity--);
                      context.read<CartBloc>().add(UpdateToCartEvent(
                          product: widget.item.product,
                          name: widget.item.name,
                          productId: widget.item.id,
                          quantity: widget.item.quantity - 1));
                    }
                        : null,
                    icon: Icon(Icons.remove),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                  Container(
                    key: ValueKey(widget.item.quantity.toString()),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.item.quantity.toString(),
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<CartBloc>().add(UpdateToCartEvent(
                          product: widget.item.product,
                          name: widget.item.name,
                          productId: widget.item.id,
                          quantity: widget.item.quantity + 1));
                    },
                    icon: Icon(Icons.add),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  context.read<CartBloc>().add(RemoveFromCartEvent(
                    cartItemId: widget.item.id,
                  ));
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                ),
              ),
            ])));
  }
}
