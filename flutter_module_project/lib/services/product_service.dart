import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class ProductService {
  // Asynchronous method to fetch a list of Products
  Future<List<ProductModel>> getProducts() async {
    try {
      const url = 'https://api.escuelajs.co/api/v1/products';
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data as List;
        final products = list.map((e) => ProductModel.fromJson(e)).toList();
        return products;
      }

      throw Exception('Something went wrong ! Try again...');
    } on SocketException {
      throw Exception('No internet ! Try again...');
    } catch (e) {
      throw Exception('Something went wrong ! Try again...');
    }
  }
}
