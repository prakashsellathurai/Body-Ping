import 'package:customer_app/provider/founderBlogApiProvider.dart';
import 'package:flutter_ghost_content_api/flutter_ghost_content_api.dart';

class FounderBlogRepository {
  final founderDataProvider = FounderApiProvider();
  Future<PostsResponse> fetchAllPosts() => founderDataProvider.getAllPosts();
  Future<PostsResponse> fetchLatestPosts() =>
      founderDataProvider.getLatestPosts();
  Future<PostsResponse> fetchPosts(int pageNumber) =>
      founderDataProvider.getPosts(pageNumber);
}
