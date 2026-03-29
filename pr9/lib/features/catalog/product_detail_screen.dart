import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cart/cart_cubit.dart';

class ProductDetailScreen extends StatelessWidget {
  final dynamic product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product['name'])),
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Блок с картинкой
            if (product['image_url'] != null && product['image_url'].isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    product['image_url'],
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                  ),
                ),
              )
            else
              const Center(
                child: Icon(Icons.image, size: 100, color: Colors.grey),
              ),
            const SizedBox(height: 24),
            
            // Название и цена
            Text(
              product['name'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${product['price']} руб.',
              style: const TextStyle(fontSize: 22, color: Colors.green, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            
            // Описание
            const Text(
              'Описание',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              product['description'] ?? 'Нет описания',
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              context.read<CartCubit>().addToCart(product['id']);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Товар добавлен в корзину'), 
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: const Text('Добавить в корзину', style: TextStyle(fontSize: 18)),
          ),
        ),
      ),
    );
  }
}