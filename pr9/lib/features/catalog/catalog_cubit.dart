import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/network/api_client.dart';

abstract class CatalogState {}
class CatalogInitial extends CatalogState {}
class CatalogLoading extends CatalogState {}
class CatalogLoaded extends CatalogState {
  final List<dynamic> products; // Список наших товаров
  CatalogLoaded(this.products);
}
class CatalogError extends CatalogState {
  final String message;
  CatalogError(this.message);
}

class CatalogCubit extends Cubit<CatalogState> {
  final ApiClient apiClient;

  CatalogCubit(this.apiClient) : super(CatalogInitial());

  Future<void> loadProducts() async {
    emit(CatalogLoading());
    try {
      final response = await apiClient.dio.get('products/');
      emit(CatalogLoaded(response.data));
    } catch (e) {
      emit(CatalogError('Не удалось загрузить каталог товаров.'));
    }
  }
}