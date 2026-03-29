import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'catalog_cubit.dart';
import '../cart/cart_cubit.dart';
import '../cart/cart_screen.dart';
import '../auth/auth_cubit.dart';
import '../auth/login_screen.dart'; 
import 'product_detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CatalogCubit>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Каталог'),
          actions: [
            // Кнопка корзины
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthCubit>().logout(); 
              },
            ),
          ],
        ),
        body: BlocBuilder<CatalogCubit, CatalogState>(
          builder: (context, state) {
            if (state is CatalogLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CatalogError) {
              return Center(child: Text(state.message));
            } else if (state is CatalogLoaded) {
              final products = state.products;
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                    title: Text(product['name']),
                    subtitle: Text('${product['price']} руб.'),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        context.read<CartCubit>().addToCart(product['id']);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Товар добавлен в корзину'), 
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
            return const Center(child: Text('Пусто'));
          },
        ),
      ),
    );
  }
}