import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BookService {
  static const String baseUrl = 'https://www.googleapis.com/books/v1/volumes';

  static Future<List<dynamic>> fetchBooks(String query) async {
    if (query.isEmpty) return [];

    final apiKey = dotenv.env['GOOGLE_BOOKS_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      print('API key is missing!');
      return [];
    }

    final response = await http.get(
      Uri.parse('$baseUrl?q=$query&key=$apiKey'),
      headers: {'Accept': 'application/json'},
    );

    print('Fetching books with query: $query');
    print('Response status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      print('Response body: ${response.body}');
      final items = json['items'] as List<dynamic>;
      return items.map((item) => item['volumeInfo']).toList();
    } else {
      print('Error fetching books: ${response.statusCode}');
      return [];
    }
  }
}
