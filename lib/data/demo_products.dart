import '../models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Product>> fetchProducts() async {
  final response = await http.get(
    Uri.parse('http://192.168.1.18:9002/api/products'),
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((product) => Product.fromJson(product)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}
