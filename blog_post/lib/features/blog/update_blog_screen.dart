import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../core/client_service/graphql_client_service.dart';
import '../../core/client_service/graphql_queries.dart';
import '../../core/common/exceptions.dart';

class UpdateBlogScreen extends StatefulWidget {
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
  State<UpdateBlogScreen> createState() => _UpdateBlogScreenState();
}

class _UpdateBlogScreenState extends State<UpdateBlogScreen> {
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
          'Update Blog',
          style: TextStyle(
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
              controller:
                  TextEditingController(text: widget.title) ?? _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: TextEditingController(text: widget.subTitle) ??
                  _subTitleController,
              decoration: InputDecoration(labelText: 'Subtitle'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller:
                  TextEditingController(text: widget.body) ?? _bodyController,
              decoration: InputDecoration(labelText: 'Body'),
              maxLines: null,
            ),
            SizedBox(height: 16.0),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () => updatePost(
                              title: _titleController.text,
                              subTitle: _subTitleController.text,
                              body: _bodyController.text,
                            ),
                    child: Text('Update'),
                  ),
          ],
        ),
      ),
    );
  }

  updatePost({
    required String title,
    required String subTitle,
    required String body,
  }) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    GraphQLClient _client = GraphQLService.client;

    try {
      final QueryResult result = await _client.mutate(
        MutationOptions(
          document: gql(updateBlogPost),
          variables: {
            'blogId': widget.blogId,
            'title': title.isEmpty ? title : widget.title,
            'subTitle': subTitle.isEmpty ? subTitle : widget.subTitle,
            'body': body.isEmpty ? body : widget.body,
          },
        ),
      );

      if (result.hasException) {
        // Handle error
        final errorMessage =
            ErrorHandlerException.getErrorMessage(result.exception);
        print('Error updating blog post: $errorMessage');
        // You can display the error message using a snackbar or dialog
        return;
      } else {
        // Blog post created successfully
        print('Blog post updated successfully:');
        print(result.data);
        // Navigate back to the previous screen
        Navigator.pop(context, true);
      }

      // Blog post updated successfully, you can navigate back or show a success message
    } catch (e) {
      // Handle error
      final errorMessage = ErrorHandlerException.getErrorMessage(e);
      print('Error updating blog post: $errorMessage');
      setState(() {
        _error = e;
        _isLoading = false;
      });
    }
  }
}
