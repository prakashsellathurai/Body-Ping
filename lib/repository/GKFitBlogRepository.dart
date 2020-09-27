import 'package:gkfit/model/wordpressModel.dart';
import 'package:gkfit/provider/wordpressProvider.dart';

class GKFitBlogRepository {
  final blogApiProvider = WordPressApiProvider(baseUrl: "url");
  Future<List<SinglePost>> fetchPosts(int page) =>blogApiProvider.getPostsByPage(page);
  Future<List<SinglePost>> fetchLatestPosts() => blogApiProvider.getLatestPosts();
}
