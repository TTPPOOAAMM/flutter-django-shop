import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/network/api_client.dart';

abstract class CartState {}
class CartInitial extends CartState {}
class CartLoading extends CartState {}
class CartLoaded extends CartState {
  final List<dynamic> items; // Товары в корзине
  final String totalPrice; // Итоговая сумма (бэкенд уже все посчитал)
  
  CartLoaded(this.items, this.totalPrice);
}
class CartError extends CartState {
  final String message;
  CartError(this.message);
}

class CartCubit extends Cubit<CartState> {
  final ApiClient apiClient;

  CartCubit(this.apiClient) : super(CartInitial());

  Future<void> loadCart() async {
    emit(CartLoading());
    try {
      final response = await apiClient.dio.get('cart/');
      emit(CartLoaded(response.data['items'], response.data['total_price']));
    } catch (e) {
      emit(CartError('Авторизуйтесь, чтобы посмотреть корзину.'));
    }
  }

  Future<void> addToCart(int productId) async {
    try {
      await apiClient.dio.post('cart/', data: {
        'product_id': productId,
        'quantity': 1,
      });
      await loadCart(); 
    } catch (e) {
      emit(CartError('Не удалось добавить товар в корзину.'));
    }
  }

  Future<void> removeFromCart(int itemId) async {
    try {
      await apiClient.dio.delete('cart/remove/$itemId/');
      await loadCart();
    } catch (e) {
      emit(CartError('Не удалось удалить товар.'));
    }
  }

  Future<void> updateQuantity(int itemId, String action) async {
    try {
      await apiClient.dio.patch(
        'cart/remove/$itemId/', 
        data: {'action': action},
      );
      await loadCart(); 
    } catch (e) {
      emit(CartError('Не удалось изменить количество.'));
    }
  }
}