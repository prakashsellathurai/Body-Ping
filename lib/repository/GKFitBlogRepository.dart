import 'package:customer_app/model/wordpressModel.dart';
import 'package:customer_app/provider/wordpressProvider.dart';

class GKFitBlogRepository {
  final blogApiProvider = WordPressApiProvider(baseUrl: "https://www.gk.fitness/wp-json/wp/v2/posts");
  Future<List<SinglePost>> fetchPosts(int page) =>blogApiProvider.getPostsByPage(page);
  Future<List<SinglePost>> fetchLatestPosts() => blogApiProvider.getLatestPosts();
}
