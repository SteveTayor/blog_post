import 'package:flutter/material.dart';

class BlogDetailScreen extends StatelessWidget {
  final String title;
  final String subTitle;
  final String body;

  BlogDetailScreen(
      {required this.title, required this.subTitle, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 15.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    body,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
