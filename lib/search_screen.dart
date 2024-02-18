import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ballsquad_task/api_service.dart';
import 'package:ballsquad_task/author_details_screen.dart';

class SearchScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Author Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search for an Author:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter author name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _searchAuthors(context);

              },
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }

  void _searchAuthors(BuildContext context) async {
    final String authorName = _searchController.text.trim();
    if (authorName.isNotEmpty) {
      try {
        final Map<String, dynamic> result = await _apiService.searchAuthors(authorName);
        final List<dynamic> authors = result['docs'];

        if (authors.isNotEmpty) {
          final author = authors.first;
          final String authorName = author['name'];
          final String birthDate = author['birth_date'] ?? 'N/A';
          final String deathDate = author['death_date'] ?? 'N/A';
          final String topWork = author['top_work'] ?? 'N/A';

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AuthorDetailsScreen(
                authorName: authorName,
                birthDate: birthDate,
                deathDate: deathDate,
                topWork: topWork,
                works: [],
              ),
            ),
          );

        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('No authors found.'),
          ));
        }
      } catch (e) {

        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to search authors. Please try again.'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter author name.'),
      ));
    }
  }

}
