import 'package:customer_app/model/wordpressModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class WordPressApiProviderAbstract {
  List<SinglePost> parsePosts(response);
  Future<List<SinglePost>> getPosts();
}
class WordPressApiProvider implements WordPressApiProviderAbstract{
String baseUrl;
WordPressApiProvider({this.baseUrl});

@override
List<SinglePost> parsePosts(response) {
  final parsed = jsonDecode(response).cast<Map<String, dynamic>>();
  return parsed.map<SinglePost>((json) => SinglePost.fromJSON(json)).toList();
}
@override
Future<List<SinglePost>> getPosts() async {
  final response = await http.get(baseUrl);
  return parsePosts(response.body);
}
@override
Future<List<SinglePost>> getLatestPosts() async {
  final response = await http.get(baseUrl+"?page=1&per_page=4");
  return parsePosts(response.body);
}
@override
Future<List<SinglePost>> getPostsByPage(int page) async {
  print(baseUrl+"?page=${page}&per_page=4");
  final response = await http.get(baseUrl+"?page=${page}&per_page=4");
  return parsePosts(response.body);
}

}

