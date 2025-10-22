import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/product.dart';

class ApiService {
  static const String BASE_URL = 'http://10.0.2.2:3000';
  static String? _authToken;

  static Map<String, String> _getHeaders() {
    final headers = {'Content-Type': 'application/json'};
    if (_authToken != null) headers['Authorization'] = 'Bearer $_authToken';
    return headers;
  }

  static void setAuthToken(String token) {
    _authToken = token;
  }

  static void clearAuthToken() {
    _authToken = null;
  }

  // ==================== AUTH ENDPOINTS ====================

  // Регистрация пользователя
  static Future<Map<String, dynamic>> register(
    String name,
    String password,
  ) async {
    final uri = Uri.parse('$BASE_URL/signup');
    try {
      final body = jsonEncode({'name': name, 'password': password});
      print('ApiService.register -> POST $uri body=$body');

      final response = await http.post(uri, headers: _getHeaders(), body: body);

      print(
        'ApiService.register <- status=${response.statusCode} body=${response.body}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        dynamic data;
        try {
          data = jsonDecode(response.body);
        } catch (_) {
          data = response.body;
        }
        // опционально: если бэкенд возвращает token
        if (data is Map && data['token'] != null) {
          _authToken = data['token'].toString();
        }
        return {'success': true, 'data': data};
      } else {
        dynamic bodyDecoded;
        try {
          bodyDecoded = jsonDecode(response.body);
        } catch (_) {
          bodyDecoded = response.body;
        }
        return {
          'success': false,
          'statusCode': response.statusCode,
          'error': bodyDecoded,
        };
      }
    } catch (e) {
      print('ApiService.register error: $e');
      return {'success': false, 'error': 'Connection error: $e'};
    }
  }

  // Логин пользователя
  static Future<Map<String, dynamic>> login(
    String name,
    String password,
  ) async {
    final uri = Uri.parse('$BASE_URL/login');
    final body = jsonEncode({'name': name, 'password': password});
    try {
      print('ApiService.login -> POST $uri body=$body');
      final response = await http.post(uri, headers: _getHeaders(), body: body);
      print(
        'ApiService.login <- status=${response.statusCode} body=${response.body}',
      );

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = response.body;
      }
      print('ApiService.login response type: ${data.runtimeType}');

      if (response.statusCode == 200) {
        if (data is Map && data.containsKey('token')) {
          final token = data['token']?.toString();
          if (token != null) setAuthToken(token);
        }
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'statusCode': response.statusCode,
          'error': data,
        };
      }
    } catch (e) {
      print('ApiService.login error: $e');
      return {'success': false, 'error': 'Connection error: $e'};
    }
  }

  // Логаут
  static Future<void> logout() async {
    try {
      await http.post(
        Uri.parse('$BASE_URL/api/v1/auth/logout'),
        headers: _getHeaders(),
      );
    } catch (e) {
      print('Logout error: $e');
    } finally {
      clearAuthToken();
    }
  }

  // ==================== PRODUCT ENDPOINTS ====================

  // Получить все продукты
  static Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/api/v1/products'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Connection error: $e');
    }
  }

  // Получить продукт по ID
  static Future<Product> fetchProductById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/api/v1/products/$id'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  // Создать новый продукт (админ)
  static Future<Product> createProduct(Map<String, dynamic> productData) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/api/v1/products'),
        headers: _getHeaders(),
        body: jsonEncode(productData),
      );

      if (response.statusCode == 201) {
        return Product.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  // Обновить продукт (админ)
  static Future<Product> updateProduct(
    int id,
    Map<String, dynamic> productData,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$BASE_URL/api/v1/products/$id'),
        headers: _getHeaders(),
        body: jsonEncode(productData),
      );

      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  // Удалить продукт (админ)
  static Future<void> deleteProduct(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$BASE_URL/api/v1/products/$id'),
        headers: _getHeaders(),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  // ==================== ORDER ENDPOINTS ====================

  // Создать заказ
  static Future<Map<String, dynamic>> createOrder(
    List<Map<String, dynamic>> items,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/api/v1/orders'),
        headers: _getHeaders(),
        body: jsonEncode({'items': items}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'error': 'Failed to create order: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Connection error: $e'};
    }
  }

  // Получить все заказы пользователя
  static Future<List<dynamic>> fetchOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/api/v1/orders'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  // Получить заказ по ID
  static Future<Map<String, dynamic>> fetchOrderById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/api/v1/orders/$id'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  // Обновить статус заказа (админ)
  static Future<void> updateOrderStatus(int id, String status) async {
    try {
      final response = await http.put(
        Uri.parse('$BASE_URL/api/v1/orders/$id/status'),
        headers: _getHeaders(),
        body: jsonEncode({'status': status}),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to update order status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }
}
