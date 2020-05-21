import 'package:cached_network_image/cached_network_image.dart';
import 'package:gkfit/model/wordpressModel.dart';
import 'package:gkfit/provider/wordpressProvider.dart';
import 'package:gkfit/screens/dashboard/your_wellness/gk_fit_blogs/gk_fit_blog_post_screen.dart';
import 'package:gkfit/widgets/animations/slide_transition_routes.dart';
import 'package:gkfit/widgets/ui/blog_list_loader.dart';
import 'package:flutter/material.dart';
import 'package:pk_skeleton/pk_skeleton.dart';

import '../dashboard_theme.dart';

class GkFitBlogListView extends StatefulWidget {
  const GkFitBlogListView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;
  @override
  _GkFitBlogListViewState createState() => _GkFitBlogListViewState();
}

class _GkFitBlogListViewState extends State<GkFitBlogListView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<String> areaListData = <String>[
    'assets/images/dashboard/area1.png',
    'assets/images/dashboard/area2.png',
    'assets/images/dashboard/area3.png',
    'assets/images/dashboard/area1.png',
  ];
  WordPressApiProvider gkfitnessBlogProvider = WordPressApiProvider(
      baseUrl: "https://www.gk.fitness/wp-json/wp/v2/posts");

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
      animation: widget.mainScreenAnimationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation.value), 0.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: FutureBuilder(
                      future: gkfitnessBlogProvider.getLatestPosts(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<SinglePost>> snapshot) {
                        if (snapshot.hasData) {
                          return GridView(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 16, bottom: 16),
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            children: List<Widget>.generate(
                              areaListData.length,
                              (int index) {
                                final int count = areaListData.length;
                                final Animation<double> animation =
                                    Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: animationController,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn),
                                  ),
                                );
                                animationController.forward();
                                return AreaView(
                                  imagepath: snapshot.data[index].featuredImage,
                                  title: snapshot.data[index].title,
                                  animation: animation,
                                  animationController: animationController,
                                );
                              },
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 24.0,
                              crossAxisSpacing: 24.0,
                              childAspectRatio: 1.0,
                            ),
                          );
                        } else {
                          return BlogLisLoader(
                            length: 2,
                          );
                        }
                      })),
            ),
          ),
        );
      },
    );
  }
}

class AreaView extends StatelessWidget {
  final String title;

  const AreaView({
    Key key,
    this.imagepath,
    this.animationController,
    this.animation,
    this.title,
  }) : super(key: key);

  final String imagepath;
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
                  0.0, 50 * (1.0 - animation.value), 0.0),
              child: Container(
                decoration: BoxDecoration(
                  color: DashboardTheme.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: DashboardTheme.grey.withOpacity(0.4),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    splashColor: DashboardTheme.nearlyDarkBlue.withOpacity(0.2),
                    onTap: () {
                      Navigator.of(context)
                          .push(SlideLeftRoute(widget: GKFITblogPostScreen()));
                    },
                    child: CachedNetworkImage(
                        imageUrl: imagepath,
                        imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0)),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  )),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16, left: 16, right: 16),
                                    child: Text(
                                      "$title",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle
                                          .apply(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                  ),
                ),
              ),
            ));
      },
    );
  }
}
