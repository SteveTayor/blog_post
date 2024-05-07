import 'dart:io';

import 'package:blog_post/core/common/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../core/client_service/graphQl_service.dart';
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
  GraphQLServices _graphQLServices = GraphQLServices();

  clear() {
    _titleController.clear();
    _subTitleController.clear();
    _bodyController.clear();
  }

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
            SizedBox(height: 30.0),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            await _graphQLServices.createPost(
                              title: _titleController.text,
                              subtitle: _subTitleController.text,
                              body: _bodyController.text,
                            );
                            clear();
                            await _graphQLServices.getAllPosts();
                            setState(() {});
                            Navigator.pop(context, true);
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Create Blog',
                          style: TextStyle(
                            fontSize: 22,
                          )),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  // void _createBlog() {
  //   setState(() {
  //     _isLoading = true;
  //     _error = null;
  //   });

  //   final String title = _titleController.text.trim();
  //   final String subTitle = _subTitleController.text.trim();
  //   final String body = _bodyController.text.trim();

  //   final createBlogMutation = useMutation(
  //     MutationOptions(
  //       document: gql(createBlogPost),
  //       variables: {
  //         'title': title,
  //         'subTitle': subTitle,
  //         'body': body,
  //       },
  //       onError: (OperationException? error) {
  //         setState(() {
  //           _isLoading = false;
  //         });
  //         _error = error.toString();
  //         print('Error creating blog post: $_error');
  //       },
  //       onCompleted: (dynamic resultData) {
  //         print('Blog post created successfully:');
  //         print(resultData);
  //         Navigator.pop(context, true);
  //       },
  //     ),
  //   );
  //   createBlogMutation.runMutation({
  //     'title': title,
  //     'subTitle': subTitle,
  //     'body': body,
  //   });
  // }
}
