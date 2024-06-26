import 'dart:async';
import 'dart:io';
import 'package:blog_post/core/client_service/graphQl_service.dart';
import 'package:blog_post/core/model/post_model.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
  Timer? _dataRefreshTimer;
  bool _isConnected = true;

  @override
  initState() {
    super.initState();
    _load();
    _dataRefreshTimer = Timer.periodic(
        Duration(seconds: 5), (_) => _load()); // Refresh every 30 seconds
    _initConnectivity();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _dataRefreshTimer?.cancel(); // Cancel the timer when the screen is disposed
  }

  _initConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  _load() async {
    if (!_isConnected) {
      return;
    }
    try {
      _blogs = null;
      _blogs = await _graphQLServices.getAllPosts();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading posts"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _load();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Posts',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: _isConnected ? _buildBody() : _buildNoInternetWidget(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (!_isConnected) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("No internet "),
                  backgroundColor: Colors.red,
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CreateBlogScreen(), // Replace with your create screen class
                ),
              );
            }
          },
          label: Text(
            '  Create',
          ),
          icon: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildNoInternetWidget() {
    return Center(
      child: Text(
        'No internet connection',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildBody() {
    return _blogs == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _blogs!.isEmpty
            ? Center(child: Text('No posts available'))
            : _buildBlogList(context, _blogs!);
  }

  Widget _buildBlogList(BuildContext context, List<PostModel> blogs) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 25.0,
        right: 25,
        bottom: 85,
      ),
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return SizedBox(height: 8);
        },
        itemCount: blogs.length,
        itemBuilder: (context, index) {
          final blog = blogs[index];
          final title = blog.title;
          final subTitle = blog.subTitle;
          final body = blog.body;
          final dateString = blog.dateCreated;
          final formattedDate =
              dateString != null ? DateFormat.yMMMd().format(dateString) : null;

          // Check if title, subTitle, and body are not empty
          if (title!.isEmpty || subTitle!.isEmpty || body!.isEmpty) {
            // Return an empty container if any of the fields are empty
            return Container();
          }

          return Card(
            child: ListTile(
                // leading: Icon(Icons.image_rounded),
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
                        date: formattedDate.toString(),
                      ),
                    ),
                  );
                },
                trailing: PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20, color: Colors.grey),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (String value) {
                    if (value == 'edit') {
                      _navigateToUpdateBlog(context, blog);
                    } else if (value == 'delete') {
                      _confirmDelete(context, blog);
                    }
                  },
                )),
          );
        },
      ),
    );
  }

  void _navigateToUpdateBlog(BuildContext context, PostModel? blog) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateBlogScreen(blogModel: blog),
      ),
    );
  }

  void _confirmDelete(BuildContext context, PostModel blog) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this post?"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[400], // Light grey color
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red, // Red color
              ),
              onPressed: () async {
                try {
                  await _graphQLServices.deletePost(id: blog.id!);
                  _load();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Post deleted successfully"),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error deleting post: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text(
                "Delete",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
