import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'features/cart/presentation/bloc/cart_event.dart';
import 'features/products/presentation/product_details/bloc/product_bloc.dart';
import 'features/products/presentation/productlist/bloc/products_bloc.dart';
import 'features/products/presentation/productlist/bloc/products_event.dart';
import 'injection_container.dart' as di;
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/products/presentation/productlist/products_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetIt.instance<ProductsBloc>()..add(GetProductsEvent())),
        BlocProvider(create: (_) => GetIt.instance<ProductBloc>()),
        BlocProvider(create: (_) => GetIt.instance<CartBloc>()..add(GetCartItemsEvent())),
      ],
      child: MaterialApp(
        title: 'E-commerce App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: ProductsPage(),
      ),
    );
  }
}