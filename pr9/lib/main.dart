import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/api_client.dart';
import 'core/storage/token_storage.dart';
import 'features/auth/auth_cubit.dart';
import 'features/catalog/catalog_cubit.dart';
import 'features/cart/cart_cubit.dart';
import 'features/auth/login_screen.dart';

void main() {
  // Инициализация сервисов
  final tokenStorage = TokenStorage();
  final apiClient = ApiClient(tokenStorage);

  runApp(MyApp(apiClient: apiClient, tokenStorage: tokenStorage));
}

class MyApp extends StatelessWidget {
  final ApiClient apiClient;
  final TokenStorage tokenStorage;

  const MyApp({super.key, required this.apiClient, required this.tokenStorage});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(apiClient, tokenStorage)),
        BlocProvider(create: (_) => CatalogCubit(apiClient)),
        BlocProvider(create: (_) => CartCubit(apiClient)),
      ],
      child: MaterialApp(
        title: 'Учебный Магазин',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const LoginScreen(),
      ),
    );
  }
}