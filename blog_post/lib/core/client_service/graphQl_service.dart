import 'package:blog_post/core/client_service/graphql_queries.dart';
import 'package:blog_post/core/model/post_model.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../common/exceptions.dart';
import 'graphql_client_service.dart';

class GraphQLServices {
  static GraphQLConfig graphQLConfig = GraphQLConfig();
  GraphQLClient client = graphQLConfig.client;

  Future<List<PostModel>> getAllPosts() async {
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(fetchAllBlogs),
        ),
      );
      if (result.hasException) {
        throw Exception(
            ErrorHandlerException.getErrorMessage(result.exception));
        // throw Exception(result.exception);
      }
      List? newResult = result.data?['allBlogPosts'];
      if (newResult == null || newResult.isEmpty) {
        return [];
      }
      List<PostModel> posts =
          newResult.map((post) => PostModel.fromMap(post)).toList();
      debugPrint(posts.toString());
      return posts;
    } catch (e) {
      throw Exception(ErrorHandlerException.getErrorMessage(e));
      // throw Exception(e);
    }
  }

  Future<PostModel> getSinglePost({
    required String id,
  }) async {
    try {
      QueryResult result = await client.query(
        QueryOptions(
            fetchPolicy: FetchPolicy.noCache,
            document: gql(fetchAllBlogs),
            variables: {
              "blogId": id,
            }),
      );
      if (result.hasException) {
        throw Exception(
            ErrorHandlerException.getErrorMessage(result.exception));
        // throw Exception(result.exception);
      }
      dynamic newResult = result.data?['blogPost'];
      // if (newResult == null || newResult.isEmpty) {
      //   return null;
      // }
      PostModel post =
          newResult.map((post) => PostModel.fromMap(post)).toList();

      return post;
    } catch (e) {
      throw Exception(ErrorHandlerException.getErrorMessage(e));
      // throw Exception(e);
    }
  }

  Future<bool> deletePost({required String id}) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(deleteBlogPost),
          variables: {"blogId": id},
        ),
      );
      if (result.hasException) {
        throw Exception(
            ErrorHandlerException.getErrorMessage(result.exception));
        // throw Exception(result.exception);
      } else {
        debugPrint(result.data.toString());
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> createPost({
    required String title,
    required String subtitle,
    required String body,
  }) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(createBlogPost),
          variables: {
            "title": title,
            "subTitle": subtitle,
            "body": body,
          },
        ),
      );
      if (result.hasException) {
        throw Exception(
            ErrorHandlerException.getErrorMessage(result.exception));
        // throw Exception(result.exception);
      } else {
        debugPrint(result.data.toString());
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatePost({
    required String id,
    required String title,
    required String subtitle,
    required String body,
  }) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(updateBlogPost),
          variables: {
            "id": id,
            "title": title,
            "subTitle": subtitle,
            "body": body,
          },
        ),
      );
      if (result.hasException) {
        throw Exception(
            ErrorHandlerException.getErrorMessage(result.exception));
        // throw Exception(result.exception);
      } else {
        debugPrint(result.data.toString());
        return true;
      }
    } catch (e) {
      return false;
    }
  }
}
