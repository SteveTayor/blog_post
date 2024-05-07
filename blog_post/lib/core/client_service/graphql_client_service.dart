import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfig {
  static HttpLink httpLink = HttpLink("https://current--demo-team-q2uchd.apollographos.net/graphql");

  // static final ValueNotifier<GraphQLClient> client = ValueNotifier(
  //   GraphQLClient(
  //     link: httpLink,
  //     cache: GraphQLCache(store: HiveStore()),
  //   ),
  // );
  GraphQLClient client = GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(),
  );
}
