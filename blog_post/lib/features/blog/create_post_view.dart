import 'dart:io';

import 'package:blog_post/core/common/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../core/client_service/graphql_client_service.dart';
import '../../core/client_service/graphql_queries.dart';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../core/client_service/graphql_queries.dart';
import '../../core/common/exceptions.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../core/client_service/graphql_client_service.dart';
import '../../core/client_service/graphql_queries.dart';
import '../../core/common/exceptions.dart';

class CreateBlogScreen extends StatefulWidget {
  @override
  _CreateBlogScreenState createState() => _CreateBlogScreenState();
}

class _CreateBlogScreenState extends State<CreateBlogScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subTitleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  bool _isLoading = false;
  dynamic _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Blog',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _subTitleController,
              decoration: InputDecoration(labelText: 'Subtitle'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(labelText: 'Message'),
              maxLines: null,
            ),
            SizedBox(height: 16.0),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _isLoading ? null : _createBlog,
                    child: Text('Create Blog'),
                  ),
            if (_error != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
                child: Text(
                  'Error: $_error',
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _createBlog() {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final String title = _titleController.text.trim();
    final String subTitle = _subTitleController.text.trim();
    final String body = _bodyController.text.trim();

    final createBlogMutation = useMutation(
      MutationOptions(
        document: gql(createBlogPost),
        variables: {
          'title': title,
          'subTitle': subTitle,
          'body': body,
        },
        onError: (OperationException? error) {
          setState(() {
            _isLoading = false;
          });
          _error = error.toString();
          print('Error creating blog post: $_error');
        },
        onCompleted: (dynamic resultData) {
          print('Blog post created successfully:');
          print(resultData);
          Navigator.pop(context, true);
        },
      ),
    );
    createBlogMutation.runMutation({
      'title': title,
      'subTitle': subTitle,
      'body': body,
    });
  }
}


//   void updatePost() async {
//     final String title = titleController.text;
//     final String subTitle = subTitleController.text;
//     final String body = bodyController.text;

//     GraphQLClient _client = GraphQLService.client;

//     try {
//       final QueryResult result = await _client.mutate(
//         MutationOptions(
//           document: gql(updateBlogPost),
//           variables: {
//             'blogId': widget.blogId,
//             'title': title,
//             'subTitle': subTitle,
//             'body': body,
//           },
//         ),
//       );

//       if (result.hasException) {
//         // Handle error
//         final errorMessage =
//             ErrorHandlerException.getErrorMessage(result.exception);
//         print('Error updating blog post: $errorMessage');
//         // You can display the error message using a snackbar or dialog
//         return;
//       }

//       // Blog post updated successfully, you can navigate back or show a success message
//     } catch (e) {
//       // Handle error
//       final errorMessage = ErrorHandlerException.getErrorMessage(e);
//       print('Error updating blog post: $errorMessage');
//     }
//   }

//   void createPost() async {
//     final String title = titleController.text;
//     final String subTitle = subTitleController.text;
//     final String body = bodyController.text;

//     GraphQLClient _client = GraphQLService.client;

//     try {
//       final QueryResult result = await _client.mutate(
//         MutationOptions(
//           document: gql(createBlogPost),
//           variables: {
//             'title': title,
//             'subTitle': subTitle,
//             'body': body,
//           },
//         ),
//       );

//       if (result.hasException) {
//         // Handle error
//         final errorMessage =
//             ErrorHandlerException.getErrorMessage(result.exception);
//         print('Error creating blog post: $errorMessage');
//         // You can display the error message using a snackbar or dialog
//         return;
//       }

//       // Blog post created successfully, you can navigate back or show a success message
//     } catch (e) {
//       // Handle error
//       final errorMessage = ErrorHandlerException.getErrorMessage(e);
//       print('Error creating blog post: $errorMessage');
//     }
//   }
// }
