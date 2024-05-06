import 'dart:io';
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
  dynamic _error;

  @override
  Widget build(BuildContext context) {
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
          _error = result.exception;
          if (_error is SocketException) {
            // Handle socket exception
            setState(() {
              _error = "Network error: Failed to connect to server";
            });
          } else {
            // Handle other GraphQL errors
            setState(() {
              _error = _error.toString();
            });
          }
          return Center(
            child: Text('Error: $_error'),
          );
        } else {
          final List<dynamic> fetchedBlogs = result.data?['allBlogPosts'];
          _blogs.clear(); // Clear existing blogs before assigning new ones
          _blogs.addAll(fetchedBlogs);
          return _buildBlogList(context, _blogs);
        }
      },
    );
  }

  Widget _buildBlogList(BuildContext context, List<dynamic> blogs) {
    return ListView.builder(
      itemCount: blogs.length,
      itemBuilder: (context, index) {
        final blog = blogs[index];
        final title = blog['title'];
        final subTitle = blog['subTitle'];
        final body = blog['body'];

        // Check if title, subTitle, and body are not empty
        if (title.isEmpty || subTitle.isEmpty || body.isEmpty) {
          // Return an empty container if any of the fields are empty
          return Container();
        }

        return Card(
          child: ListTile(
            title: Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
              ),
            ),
            subtitle: Text(
              subTitle,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            onTap: () {
              // Navigate to blog details screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlogDetailScreen(
                    title: title,
                    subTitle: subTitle,
                    body: body,
                  ),
                ),
              );
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, size: 20, color: Colors.blue),
                  onPressed: () => _navigateToUpdateBlog(context, blog),
                ),
                // _deleteBlog(blog['id']),
              ],
            ),
          ),
        );
      },
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

  Widget _deleteBlog(String blogId) {
    return Mutation(
      options: MutationOptions(
        document: gql(deleteBlogPost),
        variables: {
          'blogId': blogId,
        },
        onError: (OperationException? error) {
          if (error?.linkException is SocketException) {
            // Handle socket exception
            setState(() {
              _error = "Network error: Failed to connect to server";
            });
          } else {
            // Handle other GraphQL errors
            setState(() {
              _error = error.toString();
            });
          }
          print('Error deleting blog post: $_error');
        },
        onCompleted: (dynamic resultData) {
          // Handle completion
          print('Blog post deleted successfully');
        },
      ),
      builder: (RunMutation runMutation, QueryResult? result) {
        return IconButton(
          icon: Icon(Icons.delete, size: 20, color: Colors.red),
          onPressed: () => runMutation({'blogId': blogId}),
        );
      },
    );
  }
}
