import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_cubit.dart';
import '../catalog/product_detail_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Корзина')),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartError) {
            return Center(child: Text(state.message));
          } else if (state is CartLoaded) {
            final items = state.items;
            return Column(
              children: [
              Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final product = item['product'];
                      
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailScreen(product: product),
                                ),
                              );
                            },
                            title: Text(product['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${product['price']} руб.'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Кнопка МИНУС
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.orange),
                                  onPressed: () {
                                    context.read<CartCubit>().updateQuantity(item['id'], 'decrease');
                                  },
                                ),
                                // Текущее количество
                                Text(
                                  '${item['quantity']}', 
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                // Кнопка ПЛЮС
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                  onPressed: () {
                                    context.read<CartCubit>().updateQuantity(item['id'], 'increase');
                                  },
                                ),
                                // Кнопка УДАЛИТЬ СОВСЕМ
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () {
                                    context.read<CartCubit>().removeFromCart(item['id']);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Итого:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('${state.totalPrice} руб.', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              ],
            );
          }
          return const Center(child: Text('Корзина пуста'));
        },
      ),
    );
  }
}