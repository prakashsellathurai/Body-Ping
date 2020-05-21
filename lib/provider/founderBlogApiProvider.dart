import 'package:gkfit/constants/constants.dart';
import 'package:flutter_ghost_content_api/flutter_ghost_content_api.dart';

class FounderApiProvider {

GhostContentAPIClient ghost_client = GhostContentAPIClient(
  url: Constants.founderBlogPostApi
, version: "v2", contentAPIKey: Constants.founderBlogcontentAPIKey);

Future<PostsResponse> getAllPosts() async{
return await ghost_client.getPosts();
}

Future<PostsResponse> getLatestPosts() async{
return await ghost_client.getPosts(limit: 5);
}
Future<PostsResponse> getPosts(int pageNumber) async{
return await ghost_client.getPosts(page: pageNumber);
}
}