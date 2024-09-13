import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';

class CategoryRepository {
  static const baseUrl = String.fromEnvironment('API_URL');
  final String apiUrl = '$baseUrl/category';
  final int pageSize = 20;
  List<Category> _allCategory = [];
  List<Category> _categories = [];
  List<Category> generateCategories(int count) {
    return List.generate(
      count,
      (index) => Category(
        id: (index + 1).toString(),
        name: 'Category ${index + 1}',
      ),
    );
  }

  Future<List<Category>> fetchAllCategories() async {
    final url = Uri.parse('$apiUrl?sortBy=createdAt&sortOrder=desc');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final data = json.decode(response.body);
      final List<Category> categories = (data['data'] as List)
          .map((jsonCategory) => Category.fromJson(jsonCategory))
          .toList();
      _categories = categories;

      return _categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Category>> fetchCategories(
      int page, bool reload, bool? all) async {
    if (all == true) {
      if (_allCategory.isEmpty) {
        final allCategories = await fetchAllCategories();
        _allCategory = allCategories;
        return _allCategory;
      }
      return _allCategory;
    }

    if (_categories.isEmpty || page == 0 || reload) {
      await fetchAllCategories();
    }

    await Future.delayed(Duration(seconds: 1));
    final allCategories = _categories;
    final nextPage = page;
    final startIndex = nextPage * pageSize;
    final endIndex = startIndex + pageSize;

    if (startIndex < allCategories.length) {
      return allCategories.sublist(
        startIndex,
        endIndex > allCategories.length ? allCategories.length : endIndex,
      );
    }

    return [];
  }

  // Add a new category
  Future<void> addCategory(Category category) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(category.toJson()),
    );

    if (response.statusCode != 201) {
      final String message = json.decode(response.body)['message'];
      throw Exception(message);
    }
  }

  // Update an existing category
  Future<void> updateCategory(String id, Category category) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(category.toJson()),
    );

    if (response.statusCode != 200) {
      final String message = json.decode(response.body)['message'];
      throw Exception(message);
    }
  }

  // Delete a category
  Future<void> deleteCategory(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode != 202) {
      final String message = json.decode(response.body)['message'];
      throw Exception(message);
    }
  }

  // Search categories locally
  List<Category> searchCategories(String query) {
    if (query.isEmpty) {
      return _categories;
    }

    return _categories.where((category) {
      return category.name.toLowerCase().contains(query.toLowerCase()) ||
          (category.description?.toLowerCase().contains(query.toLowerCase()) ??
              false);
    }).toList();
  }
}
