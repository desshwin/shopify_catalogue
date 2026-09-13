import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiService {
  static const String _baseUrl = 'https://dummyjson.com';

  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Product>> getProducts({int limit = 20, int skip = 0}) async {
    try {
      final url = Uri.parse('$_baseUrl/products?limit=$limit&skip=$skip');

      final response = await client.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsJson = data['products'];

        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: Server responded with status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error. Please check your internet connection.');
    }
  }

  Future<List<Product>> searchProducts(String query, {int limit = 20, int skip = 0}) async {
    try {
      final url = Uri.parse('$_baseUrl/products/search?q=$query&limit=$limit&skip=$skip');
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsJson = data['products'];

        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search products: Server responded with status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error. Please check your internet connection.');
    }
  }
}