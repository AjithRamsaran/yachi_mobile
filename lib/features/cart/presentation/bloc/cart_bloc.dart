import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachii/features/cart/domain/usecases/update_to_cart.dart';
import '../../../../core/websocket/websocket_service.dart';
import '../../domain/usecases/add_to_cart.dart';
import '../../domain/usecases/get_cart_items.dart';
import '../../domain/usecases/get_orders.dart';
import '../../domain/usecases/remove_from_cart.dart';
import '../../domain/usecases/place_order.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final AddToCart addToCart;
  final UpdateToCart updateToCart;
  final GetCartItems getCartItems;
  final RemoveFromCart removeFromCart;
  final PlaceOrder placeOrder;
  final GetOrders getOrders;
  final WebSocketService webSocketService;
  late StreamSubscription _webSocketSubscription;

  CartBloc({
    required this.addToCart,
    required this.updateToCart,
    required this.getCartItems,
    required this.removeFromCart,
    required this.placeOrder,
    required this.webSocketService,
    required this.getOrders
  }) : super(CartInitial()) {
    on<GetCartItemsEvent>(_onGetCartItems);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateToCartEvent>(_onUpdateToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<PlaceOrderEvent>(_onPlaceOrder);
    on<CartUpdatedEvent>(_onCartUpdated);
    _initWebSocket();
  }

  void _initWebSocket() async {
    await webSocketService.connect();
    _webSocketSubscription = webSocketService.cartUpdates.listen((data) {
      add(CartUpdatedEvent(data: data));
    });
  }

  void _onGetCartItems(GetCartItemsEvent event, Emitter<CartState> emit) async {
    if (event.isFromUI) {
      emit(CartLoading());
    }
    final result = await getCartItems();
    result.fold(
      (failure) => emit(CartError(message: 'Failed to load cart items')),
      (items) => emit(CartLoaded(items: items)),
    );
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    final result = await addToCart(
        event.productId, event.quantity, event.name, event.product);
    result.fold(
      (failure) => emit(CartError(message: 'Failed to add item to cart')),
      (_) => add(GetCartItemsEvent()),
    );
  }

  void _onUpdateToCart(UpdateToCartEvent event, Emitter<CartState> emit) async {
    final result = await updateToCart(
        event.productId, event.quantity, event.name, event.product);
    result.fold(
      (failure) => emit(CartError(message: 'Failed to update item to cart')),
      (_) => add(GetCartItemsEvent(isFromUI: false)),
    );
  }

  void _onRemoveFromCart(
      RemoveFromCartEvent event, Emitter<CartState> emit) async {
    final result = await removeFromCart(event.cartItemId);
    result.fold(
      (failure) => emit(CartError(message: 'Failed to remove item from cart')),
      (_) => add(GetCartItemsEvent()),
    );
  }

  void _onPlaceOrder(PlaceOrderEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final result = await placeOrder(event.cartItems, event.totalPrice);
    result.fold(
      (failure) => emit(CartError(message: 'Failed to place order')),
      (_) => emit(OrderPlaced()),
    );
  }

  void _onCartUpdated(CartUpdatedEvent event, Emitter<CartState> emit) {
    add(GetCartItemsEvent(isFromUI: false));
  }

  @override
  Future<void> close() {
    _webSocketSubscription.cancel();
    webSocketService.disconnect();
    return super.close();
  }
}
