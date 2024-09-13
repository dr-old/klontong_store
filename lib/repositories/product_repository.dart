import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductRepository {
  static const baseUrl = String.fromEnvironment('API_URL');
  final String apiUrl = '$baseUrl/product';
  final int pageSize = 10;
  List<Product> _products = [];

  List<Product> generateProducts(int count) {
    return List.generate(
      count,
      (index) => Product(
        id: (index + 1).toString(),
        categoryId: '1',
        categoryName: 'Category ${index + 1}',
        sku: 'SKU${index + 1}',
        name: 'Product ${index + 1}',
        description: 'Description for product ${index + 1}',
        weight: 100,
        width: 10,
        length: 10,
        height: 10,
        image: 'https://via.placeholder.com/150',
        price: 1000,
      ),
    );
  }

  Future<List<Product>> fetchAllProducts() async {
    final url = Uri.parse('$apiUrl?sortBy=createdAt&sortOrder=desc');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final data = json.decode(response.body);
      final List<Product> products = (data['data'] as List)
          .map((jsonProduct) => Product.fromJson(jsonProduct))
          .toList();
      _products = products;

      return _products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Product>> fetchProducts(
      int page, bool reload, String category) async {
    if (_products.isEmpty || page == 0 || reload) {
      await fetchAllProducts();
    }

    await Future.delayed(Duration(seconds: 1));
    final allProducts = _products;
    final startIndex = page * pageSize;
    final endIndex = startIndex + pageSize;

    if (startIndex < allProducts.length) {
      return allProducts.sublist(
        startIndex,
        endIndex > allProducts.length ? allProducts.length : endIndex,
      );
    }

    return [];
  }

  // Add a new product
  Future<String> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(product.toJson()),
    );
    final Map<String, dynamic> responseBody = json.decode(response.body);
    final String message = responseBody['message'];
    if (response.statusCode != 201) {
      throw Exception(message);
    }
    return message;
  }

  // Update an existing product
  Future<String> updateProduct(String id, Product product) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(product.toJson()),
    );
    final Map<String, dynamic> responseBody = json.decode(response.body);
    final String message = responseBody['message'];
    if (response.statusCode != 200) {
      throw Exception(message);
    }
    return message;
  }

  // Delete a product
  Future<String> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    final Map<String, dynamic> responseBody = json.decode(response.body);
    final String message = responseBody['message'];
    if (response.statusCode != 202) {
      throw Exception(message);
    }
    return message;
  }

  // Search products locally
  List<Product> searchProducts(String query) {
    if (query.isEmpty) {
      return _products;
    }

    return _products.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase()) ||
          product.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
