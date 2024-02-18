import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> searchAuthors(String name) async {
    try {
      final response = await _dio.get(
        'https://openlibrary.org/search/authors.json',
        queryParameters: {'q': name},
      );
      return response.data;
    } catch (error) {
      throw Exception('Failed to search authors: $error');
    }
  }

  Future<Map<String, dynamic>> getAuthorWorks(String authorId) async {
    try {
      final response = await _dio.get(
        'https://openlibrary.org$authorId/works.json',
      );
      return response.data;
    } catch (error) {
      throw Exception('Failed to fetch author works: $error');
    }
  }

  Future<Map<String, dynamic>> getWorkDetails(String workId) async {
    try {
      final response = await _dio.get(
        'https://openlibrary.org$workId.json',
      );
      return response.data;
    } catch (error) {
      throw Exception('Failed to fetch work details: $error');
    }
  }
}
