import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiService {
  // Problem: Hardcoded URL, no error handling, crashes if status code is not 200 or internet fails
  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products'));

    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> productsJson = data['products'];

    return productsJson.map((json) => Product.fromJson(json)).toList();
  }
}