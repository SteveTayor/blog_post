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
  void initState() {
    super.initState();
    _titleController.text = widget.title;
    _subTitleController.text = widget.subTitle;
    _bodyController.text = widget.body;
  }

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

  void updatePost({
    required String title,
    required String subTitle,
    required String body,
  }) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final updateBlogMutation = useMutation(
      MutationOptions(
        document: gql(updateBlogPost),
        variables: {
          'blogId': widget.blogId,
          'title': title,
          'subTitle': subTitle,
          'body': body,
        },
        onError: (OperationException? error) {
          setState(() {
            _isLoading = false;
          });
          _error = ErrorHandlerException.getErrorMessage(error);
          print('Error updating blog post: $_error');
        },
        onCompleted: (dynamic resultData) {
          print('Blog post updated successfully:');
          print(resultData);
          Navigator.pop(context, true);
        },
      ),
    );

    updateBlogMutation.runMutation({
      'title': title,
      'subTitle': subTitle,
      'body': body,
    });
  }
}
