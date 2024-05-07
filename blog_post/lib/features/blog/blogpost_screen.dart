import 'dart:io';
import 'package:blog_post/core/client_service/graphQl_service.dart';
import 'package:blog_post/core/model/post_model.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../core/client_service/graphql_client_service.dart';
import '../../core/client_service/graphql_queries.dart';
import '../../core/common/exceptions.dart';
import 'package:intl/intl.dart';
import 'blog_details_screen.dart';
import 'create_post_view.dart';
import 'update_blog_screen.dart';

class BlogPostScreen extends StatefulWidget {
  _BlogPostScreenState createState() => _BlogPostScreenState();
}

class _BlogPostScreenState extends State<BlogPostScreen> {
  List<PostModel>? _blogs;
  dynamic _error;
  GraphQLServices _graphQLServices = GraphQLServices();

  @override
  initState() {
    super.initState();
    _load();
  }

  void _load() async {
    _blogs = null;
    _blogs = await _graphQLServices.getAllPosts();
    setState(() {});
  }

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
    return _blogs == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _blogs!.isEmpty
            ? Center(child: Text('No posts'))
            : _buildBlogList(context, _blogs!);
  }

  Widget _buildBlogList(BuildContext context, List<PostModel> blogs) {
    return ListView.builder(
      itemCount: blogs.length,
      itemBuilder: (context, index) {
        final blog = blogs[index];
        debugPrint(blog.toString());
        final title = blog.title;
        final subTitle = blog.subTitle;
        final body = blog.body;
        debugPrint('title : ${title.toString()}');
        debugPrint('subtitle : ${subTitle.toString()}');
        debugPrint('body : ${body.toString()}');
        final dateString = blog.dateCreated;
        final dateCreated = DateTime.parse(dateString as String);
        final formattedDate = DateFormat.yMMMd().format(dateCreated);

        // Check if title, subTitle, and body are not empty
        if (title!.isEmpty || subTitle!.isEmpty || body!.isEmpty) {
          // Return an empty container if any of the fields are empty
          return Container();
        }

        return Card(
          child: ListTile(
            leading: Icon(Icons.post_add_rounded),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subTitle,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  '$formattedDate', // Display formatted date
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
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
                IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _graphQLServices.deletePost(id: blog.id!);
                      _load();
                    }),
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
