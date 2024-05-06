import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../core/client_service/graphql_client_service.dart';
import '../../core/client_service/graphql_queries.dart';
import '../../core/common/exceptions.dart';
import 'blog_details_screen.dart';
import 'create_post_view.dart';
import 'update_blog_screen.dart';

class BlogPostScreen extends StatefulWidget {
  @override
  _BlogPostScreenState createState() => _BlogPostScreenState();
}

class _BlogPostScreenState extends State<BlogPostScreen> {
  List<dynamic> _blogs = [];
  bool _isLoading = true;
  dynamic _error;

  @override
  void initState() {
    super.initState();
    // _fetchBlogs();
  }

  // Future<void> _fetchBlogs() async {
  //   try {
  //     final QueryResult result = await GraphQLService.client
  //         .query(QueryOptions(document: gql(fetchAllBlogs)));
  //     if (result.hasException) {
  //       setState(() {
  //         _error = result.exception;
  //         _isLoading = false;
  //       });
  //     } else {
  //       setState(() {
  //         _blogs = result.data!['allBlogPosts'];
  //         _isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _error = e;
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Blog Posts',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      final errorMessage = ErrorHandlerException.getErrorMessage(_error);
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Blog Posts',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Text('Error: $errorMessage'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Blog Posts',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CreateBlogScreen(), // Replace with your create screen class
            ),
          );
        },
        label: Text(
          '  Create',
        ),
        icon: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (_error != null) {
      final errorMessage = ErrorHandlerException.getErrorMessage(_error);
      return Center(
        child: Text('Error: $errorMessage'),
      );
    } else {
      return Query(
        options: QueryOptions(
          document: gql(fetchAllBlogs),
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (result.hasException) {
            setState(() {
              _error = result.exception;
            });
            return Center(
              child: Text('Error: ${result.exception.toString()}'),
            );
          } else {
            _blogs = result.data!['allBlogPosts'];
            print(_blogs.toString());
            return _buildBlogList(context);
          }
        },
      );
    }
  }

  Widget _buildBlogList(BuildContext context) {
    setState(() {
      // _error = result.exception;
      _isLoading = false;
    });
    return Padding(
      padding: const EdgeInsets.only(
        left: 25.0,
        right: 25,
        bottom: 25,
      ),
      child: ListView.builder(
        itemCount: _blogs.length,
        itemBuilder: (context, index) {
          final blog = _blogs[index];
          return Card(
            child: Container(
              child: ListTile(
                title: Text(
                  blog['title'],
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                subtitle: Text(
                  blog['subTitle'],
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, size: 20, color: Colors.blue),
                      onPressed: () => _navigateToUpdateBlog(context, blog),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, size: 20, color: Colors.red),
                      onPressed: () => _deleteBlog(blog['id']),
                    ),
                  ],
                ),
                onTap: () {
                  // Navigate to blog details screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlogDetailScreen(
                        title: blog['title'],
                        subTitle: blog['subTitle'],
                        body: blog['body'],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToUpdateBlog(BuildContext context, dynamic blog) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateBlogScreen(
          blogId: blog['id'],
          title: blog['title'],
          subTitle: blog['subTitle'],
          body: blog['body'],
        ),
      ),
    );
  }

  void _deleteBlog(String blogId) async {
    GraphQLClient _client = GraphQLService.client;

    try {
      final QueryResult result = await _client.mutate(
        MutationOptions(
          document: gql(deleteBlogPost),
          variables: {
            'blogId': blogId,
          },
        ),
      );

      if (result.hasException) {
        // Handle error
        final errorMessage =
            ErrorHandlerException.getErrorMessage(result.exception);
        print('Error deleting blog post: $errorMessage');
        // You can display the error message using a snackbar or dialog
        return;
      }

      // Blog post updated successfully, you can navigate back or show a success message
    } catch (e) {
      // Handle error
      final errorMessage = ErrorHandlerException.getErrorMessage(e);
      print('Error deleting blog post: $errorMessage');
    }
  }
}
