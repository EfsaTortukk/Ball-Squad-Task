import 'package:flutter/material.dart';
import 'package:ballsquad_task/api_service.dart';
import 'package:ballsquad_task/work_details_screen.dart';

class AuthorDetailsScreen extends StatefulWidget {
  final String authorName;
  final String birthDate;
  final String deathDate;
  final String topWork;
  final List<String> works;

  AuthorDetailsScreen({
    required this.authorName,
    required this.birthDate,
    required this.deathDate,
    required this.topWork,
    required this.works,
  });

  @override
  _AuthorDetailsScreenState createState() => _AuthorDetailsScreenState();
}

class _AuthorDetailsScreenState extends State<AuthorDetailsScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWorks();
  }

  Future<void> _fetchWorks() async {
    try {
      final List<String> works = [];

      for (String workId in widget.works) {
        final Map<String, dynamic> workResult = await _apiService.getWorkDetails(workId);
        works.add(workResult['title'] ?? 'N/A');
      }

      setState(() {
        widget.works.clear();
        widget.works.addAll(works);
        _isLoading = false;
      });
    } catch (e) {
      // Handle error
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Author Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Author: ${widget.authorName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Birth Date: ${widget.birthDate}'),
            SizedBox(height: 8),
            Text('Death Date: ${widget.deathDate}'),
            SizedBox(height: 16),
            Text(
              'Top Work: ${widget.topWork}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Works:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildWorksList(),
          ],
        ),
      ),
    );
  }

  Widget _buildWorksList() {
    return widget.works.isNotEmpty
        ? Expanded(
      child: ListView.builder(
        itemCount: widget.works.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.works[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkDetailsScreen(
                    workTitle: widget.works[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    )
        : Text('No works found');
  }
}
