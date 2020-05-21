import 'package:cached_network_image/cached_network_image.dart';
import 'package:gkfit/screens/dashboard/founder/blog/blog_post.dart';
import 'package:gkfit/widgets/loading/shimmer_box.dart';
import 'package:flutter_ghost_content_api/flutter_ghost_content_api.dart';

import '../dashboard_theme.dart';
import 'package:flutter/material.dart';


class BlogListView extends StatefulWidget {
  PostsResponse latestBlogpostSnapshotData;

  BlogListView(
      {Key key,
      this.mainScreenAnimationController,
      this.mainScreenAnimation,
      this.latestBlogpostSnapshotData})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;

  @override
  _BlogListViewState createState() =>
      _BlogListViewState(latestBlogpostSnapshotData);
}

class _BlogListViewState extends State<BlogListView>
    with TickerProviderStateMixin {
  AnimationController animationController;

  PostsResponse latestBlogpostSnapshotData;

  _BlogListViewState(this.latestBlogpostSnapshotData);

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController.view,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation.value), 0.0),
            child: Container(
              height: 216,
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: latestBlogpostSnapshotData.posts.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count = latestBlogpostSnapshotData.posts.length > 10
                      ? 10
                      : latestBlogpostSnapshotData.posts.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController.forward();

                  return BlogSlideView(
                    latestBlogpostSingleSnapshotData:
                        latestBlogpostSnapshotData.posts[index],
                    animation: animation,
                    animationController: animationController,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class BlogSlideView extends StatelessWidget {
  PostPage latestBlogpostSingleSnapshotData;

  BlogSlideView(
      {Key key,
      this.latestBlogpostSingleSnapshotData,
      this.animationController,
      this.animation})
      : super(key: key);

  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        BlogScreen(postData: latestBlogpostSingleSnapshotData),
                  ),
                );
              },
              child: SizedBox(
                width: 130,
                child: Stack(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 32, left: 8, right: 8, bottom: 16),
                        child: CachedNetworkImage(
                          placeholder: (context, url) =>
                              ShimmerBox(width: 130, height: 150),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          imageUrl:
                              latestBlogpostSingleSnapshotData.featureImage,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0)),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 54, left: 16, right: 16, bottom: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    latestBlogpostSingleSnapshotData.title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: DashboardTheme.fontName,
                                      fontWeight: FontWeight.bold,
                                      color: DashboardTheme.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
