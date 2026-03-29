import 'package:dio/dio.dart';
import '../storage/token_storage.dart';

class ApiClient {
  late final Dio dio;
  final TokenStorage _tokenStorage;

  //  на Android-эмуляторе, 10.0.2.2
  //  на Windows/Linux приложение,  127.0.0.1
  static const String baseUrl = 'http://10.0.2.2:8000/api/'; 

  ApiClient(this._tokenStorage) {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Проверяем, куда идет запрос. Если это НЕ логин и НЕ регистрация...
          if (!options.path.contains('login') && !options.path.contains('register')) {
            final token = await _tokenStorage.getAccessToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
      ),
    );
  }
}