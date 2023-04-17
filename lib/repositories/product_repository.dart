import 'dart:convert';

import '../models/course.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  Future<Course> findByName(String name) async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/products?name=$name'));

    if (response.statusCode != 200) {
      throw Exception();
    }

    final responseData = jsonDecode(response.body);

    if (responseData.isEmpty) {
      throw Exception('Produto não encontrado');
    }

    return Course.fromMap(responseData.first);
  }
}
