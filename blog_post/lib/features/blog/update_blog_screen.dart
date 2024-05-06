import 'package:flutter/material.dart';

class UpdateBlogScreen extends StatelessWidget {
  final String blogId;
  final String title;
  final String subTitle;
  final String body;

  UpdateBlogScreen({
    required this.blogId,
    required this.title,
    required this.subTitle,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Blog',style: TextStyle(
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: TextEditingController(text: title),
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: TextEditingController(text: subTitle),
              decoration: InputDecoration(labelText: 'Subtitle'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: TextEditingController(text: body),
              decoration: InputDecoration(labelText: 'Body'),
              maxLines: null,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Implement logic to update the blog post
                // You can use the blogId, title, subTitle, and body properties
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
