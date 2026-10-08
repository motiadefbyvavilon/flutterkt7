import 'package:dio/dio.dart';
import '../models/post.dart';

/// Собственное исключение для удобной обработки в UI.
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

/// Сервис для работы с API через Dio.
class ApiService {
  // Базовый URL публичного тестового API.
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
        headers: {'Accept': 'application/json'},
      ),
    );
  }

  /// Бросает [ApiException] с понятным сообщением в случае ошибки.
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await _dio.get<List<dynamic>>('/posts');

      final data = response.data;
      if (data == null) {
        throw ApiException('Сервер вернул пустой ответ');
      }

      return Post.fromJsonList(data);
    } on DioException catch (e) {
      throw ApiException(_mapDioError(e));
    } catch (e) {
      // Любая другая ошибка (например, ошибка парсинга)
      throw ApiException('Не удалось обработать данные: $e');
    }
  }

  /// Преобразует ошибку Dio в понятное пользователю сообщение.
  /// Преобразует ошибку Dio в понятное пользователю сообщение.
  String _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout: // ← новый тип
        return 'Превышено время ожидания. Проверьте интернет.';
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        return 'Ошибка сервера: $code';
      case DioExceptionType.connectionError:
        return 'Нет соединения с интернетом.';
      case DioExceptionType.cancel:
        return 'Запрос отменён.';
      case DioExceptionType.badCertificate:
        return 'Ошибка сертификата.';
      case DioExceptionType.unknown:
        return 'Неизвестная ошибка: ${e.message ?? 'проверьте URL'}';
    }
  }
}
