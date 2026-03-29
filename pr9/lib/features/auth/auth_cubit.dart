import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/token_storage.dart';

// Состояния авторизации
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

// Сам Cubit
class AuthCubit extends Cubit<AuthState> {
  final ApiClient apiClient;
  final TokenStorage tokenStorage;

  AuthCubit(this.apiClient, this.tokenStorage) : super(AuthInitial());

  // Логин
  Future<void> login(String username, String password) async {
    emit(AuthLoading()); // Показываем крутилку загрузки
    try {
      final response = await apiClient.dio.post('login/', data: {
        'username': username,
        'password': password,
      });
      // Сохраняем токены локально
      await tokenStorage.saveTokens(
        access: response.data['access'],
        refresh: response.data['refresh'],
      );
      emit(AuthAuthenticated()); // Успешный вход
    } catch (e) {
      emit(AuthError('Ошибка входа. Проверьте логин и пароль.'));
    }
  }

  // Регистрация
  Future<void> register(String username, String email, String password) async {
    emit(AuthLoading());
    try {
      await apiClient.dio.post('register/', data: {
        'username': username,
        'email': email,
        'password': password,
      });
      // После успешной регистрации сразу логиним пользователя
      await login(username, password);
    } catch (e) {
      emit(AuthError('Ошибка регистрации. Возможно, пользователь уже существует.'));
    }
  }

  // Выход
  Future<void> logout() async {
    await tokenStorage.deleteTokens();
    emit(AuthInitial());
  }
}