import 'package:flutter/material.dart';

class BlogDetailScreen extends StatelessWidget {
  final String title;
  final String subTitle;
  final String body;
  final String date;

  BlogDetailScreen({
    required this.title,
    required this.subTitle,
    required this.body,
    required this.date,
  });

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
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Subtitle: $subTitle',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 15.0),
            Flexible(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Body: $body',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Date created: $date',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.0,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
