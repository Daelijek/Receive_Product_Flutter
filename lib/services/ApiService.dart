import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/product.dart';

class ApiService {
  static const String BASE_URL = 'http://10.0.2.2:3000';
  static String? _authToken;

  static String? currentUsername;
  static String? getCurrentUsername() => currentUsername;

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


  static Future<Map<String, dynamic>> register(
    String name,
    String password,
  ) async {
    final uri = Uri.parse('$BASE_URL/signup');
    final body = jsonEncode({'name': name, 'password': password});
    try {
      final response = await http.post(uri, headers: _getHeaders(), body: body);
      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = response.body;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data is Map) {
          if (data['token'] != null) setAuthToken(data['token'].toString());
          if (data['name'] != null)
            currentUsername = data['name'].toString();
          else if (data['user'] is Map && data['user']['name'] != null)
            currentUsername = data['user']['name'].toString();
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
      final response = await http.post(uri, headers: _getHeaders(), body: body);
      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = response.body;
      }

      String? extractToken(dynamic d) {
        if (d == null) return null;
        if (d is String) return null;
        if (d is Map) {
          if (d['token'] != null) return d['token']?.toString();
          if (d['access_token'] != null) return d['access_token']?.toString();
          if (d['data'] is Map) {
            if (d['data']['token'] != null)
              return d['data']['token']?.toString();
            if (d['data']['access_token'] != null)
              return d['data']['access_token']?.toString();
          }
          if (d['user'] is Map && d['user']['token'] != null)
            return d['user']['token']?.toString();
        }
        return null;
      }

      if (response.statusCode == 200) {
        if (data is Map) {
          final token = extractToken(data);
          if (token != null && token.isNotEmpty) setAuthToken(token);
          if (data['name'] != null)
            currentUsername = data['name'].toString();
          else if (data['user'] is Map && data['user']['name'] != null)
            currentUsername = data['user']['name'].toString();
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


  static Future<List<Product>> fetchProducts() async {
    final uri = Uri.parse('$BASE_URL/products');

    try {
      final response = await http.get(uri, headers: _getHeaders());
      print('Fetched products JSON: ${response.body}');

      print(
        'ApiService.fetchProducts -> GET $uri status=${response.statusCode} body=${response.body}',
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return decoded.map<Product>((item) {
            return Product.fromJson(item as Map<String, dynamic>);
          }).toList();
        } else {
          throw Exception('Unexpected response format: ${decoded.runtimeType}');
        }
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

  // Создать новый продукт
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

  // Обновить продукт
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

  // Удалить продукт
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


  // Создать заказ
  static Future<Map<String, dynamic>> createOrder({
    required dynamic productId,
    required int quantity,
  }) async {
    final uri = Uri.parse('$BASE_URL/orders');
    final body = jsonEncode({
      'product_id': productId,
      'quantity': quantity,
      if (currentUsername != null) 'username': currentUsername,
    });

    try {
      print('ApiService.createOrder -> POST $uri body=$body');
      final response = await http.post(uri, headers: _getHeaders(), body: body);
      print(
        'ApiService.createOrder <- status=${response.statusCode} body=${response.body}',
      );

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = response.body;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'statusCode': response.statusCode,
          'error': data,
        };
      }
    } catch (e) {
      print('ApiService.createOrder error: $e');
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

  // Обновить статус заказа
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
