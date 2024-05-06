import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  static final HttpLink httpLink =
      HttpLink("https://uat-api.vmodel.app/graphql/");

  static final ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );
  // static final GraphQLClient client = GraphQLClient(
  //   link: httpLink,
  //   cache: GraphQLCache(),
  // );
}
