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
  TextEditingController _titleController = TextEditingController();
  TextEditingController _subTitleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();
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
  void dispose() {
    // Dispose the controllers
    _titleController.dispose();
    _subTitleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    // Reload the blog list
    final blogList = await _graphQLServices.getAllPosts();
    setState(() {
      widget.blogModel = blogList.firstWhere(
        (blog) => blog.id == widget.blogModel!.id,
        orElse: () => widget.blogModel!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Post',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _subTitleController,
                textInputAction: TextInputAction.newline,
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
                      onPressed: _isLoading
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });

                              try {
                                await _graphQLServices.updatePost(
                                  id: widget.blogModel!.id.toString(),
                                  title: _titleController.text,
                                  subtitle: _subTitleController.text,
                                  body: _bodyController.text,
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Post updated successfully',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                // Reload the blog list
                                await _load();

                                Navigator.pop(context, true);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Error occurred updating post',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } finally {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8,
                          top: 8,
                          bottom: 20,
                        ),
                        child: Text(
                          'Update',
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
