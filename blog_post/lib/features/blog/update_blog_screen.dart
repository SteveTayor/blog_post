import 'package:blog_post/features/blog/blogpost_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../core/client_service/graphQl_service.dart';
import '../../core/client_service/graphql_client_service.dart';
import '../../core/client_service/graphql_queries.dart';
import '../../core/common/exceptions.dart';
import '../../core/model/post_model.dart';

class UpdateBlogScreen extends StatefulWidget {
  PostModel? blogModel;

  UpdateBlogScreen({
    required this.blogModel,
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
  GraphQLServices _graphQLServices = GraphQLServices();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.blogModel!.title!;
    _subTitleController.text = widget.blogModel!.subTitle!;
    _bodyController.text = widget.blogModel!.body!;
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
                        : () async {
                            _graphQLServices.updatePost(
                              id: widget.blogModel!.id!,
                              title: _titleController.text,
                              subtitle: _subTitleController.text,
                              body: _bodyController.text,
                            );
                            await _graphQLServices.getAllPosts();
                            setState(() {});
                            ScaffoldMessengerState().showSnackBar(SnackBar(
                              content: Text(
                                'post updated successfully',
                              ),
                              backgroundColor: Colors.green,
                            ));
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BlogPostScreen()),
                            );
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Update',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    )),
          ],
        ),
      ),
    );
  }

  // void updatePost({
  //   required String title,
  //   required String subTitle,
  //   required String body,
  // }) async {
  //   setState(() {
  //     _isLoading = true;
  //     _error = null;
  //   });

  //   final updateBlogMutation = useMutation(
  //     MutationOptions(
  //       document: gql(updateBlogPost),
  //       variables: {
  //         'blogId': widget.blogId,
  //         'title': title,
  //         'subTitle': subTitle,
  //         'body': body,
  //       },
  //       onError: (OperationException? error) {
  //         setState(() {
  //           _isLoading = false;
  //         });
  //         _error = ErrorHandlerException.getErrorMessage(error);
  //         print('Error updating blog post: $_error');
  //       },
  //       onCompleted: (dynamic resultData) {
  //         print('Blog post updated successfully:');
  //         print(resultData);
  //         Navigator.pop(context, true);
  //       },
  //     ),
  //   );

  //   updateBlogMutation.runMutation({
  //     'title': title,
  //     'subTitle': subTitle,
  //     'body': body,
  //   });
  // }
}
