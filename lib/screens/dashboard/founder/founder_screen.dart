import 'package:customer_app/bloc/founder_blog_post_bloc.dart';
import 'package:customer_app/constants/colors.dart';
import 'package:customer_app/screens/dashboard/founder/about/about_founder.dart';
import 'package:customer_app/screens/dashboard/founder/blog_list_view.dart';
import 'package:customer_app/screens/dashboard/founder/loading_blog_list.dart';
import 'package:customer_app/screens/dashboard/founder/tweet/founder_tweets.dart';
import 'package:customer_app/widgets/animations/slide_transition_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ghost_content_api/flutter_ghost_content_api.dart';

import '../ui_view/title_view.dart';
import '../dashboard_theme.dart';
import 'package:flutter/material.dart';

import 'blog/founder_blog_screen.dart';

class FounderScreen extends StatefulWidget {
  const FounderScreen({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _FounderScreenState createState() => _FounderScreenState();
}

class _FounderScreenState extends State<FounderScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  List<Widget> listViews;
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  Widget _bloglistGallery(animationController, latestBlogpostSnapshotData) {
    return BlogListView(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: animationController,
                curve:
                    Interval((1 / 9) * 3, 1.0, curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: animationController,
        latestBlogpostSnapshotData: latestBlogpostSnapshotData);
  }

  Widget _cardScreen(BuildContext context) {
    final founderBlogBloc = FounderBlogPostBloc();
    founderBlogBloc.fetchLatestPosts();
    return Card(
        elevation: 40,
        color: base_color_monochrome_1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45),
            topRight: Radius.circular(45),
          ),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * (3 / 4),
          width: MediaQuery.of(context).size.width,
          child: Container(
              padding: EdgeInsets.all((MediaQuery.of(context).size.width) /
                  (MediaQuery.of(context).size.height) *
                  20),
              child: StreamBuilder(
                stream: founderBlogBloc.latestBlogdata,
                builder: (context,  AsyncSnapshot<PostsResponse> latestBlogpostSnapshot) {
                  if (latestBlogpostSnapshot.hasData) {
                    return Column(children: <Widget>[
                      TitleView(
                        titleTxt: 'Latest updates',
                        subTxt: 'Read More',
                        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: widget.animationController,
                                curve: Interval((1 / 9) * 0, 1.0,
                                    curve: Curves.fastOutSlowIn))),
                        animationController: widget.animationController,
                        onclick: () {
                          Navigator.of(context).push(
                             SlideLeftRoute(widget:
                             BlocProvider(create: (context) => FounderBlogPostBloc()..add(FounderBlogPostFetch()),
                             child:  FounderblogScreen(),
                             )
                             ));
                        },
                      ),
                      _bloglistGallery(widget.animationController,
                          latestBlogpostSnapshot.data),
                      TitleView(
                        titleTxt: 'Tweets',
                        subTxt: 'More',
                        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: widget.animationController,
                                curve: Interval((1 / 9) * 0, 1.0,
                                    curve: Curves.fastOutSlowIn))),
                        animationController: widget.animationController,
                        onclick: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Foundertweets()));
                        },
                      ),
                      TitleView(
                        titleTxt: 'About Mr.GK Reddy',
                        subTxt: 'Details',
                        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: widget.animationController,
                                curve: Interval((1 / 9) * 0, 1.0,
                                    curve: Curves.fastOutSlowIn))),
                        animationController: widget.animationController,
                        onclick: () {
                          Navigator.of(context).push(
                              SlideLeftRoute(widget:AboutFounderScreen()));
                        },
                      ),
                    ]);
                  } else {
                    return LoadingBlogList();
                  }
                },
              )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    listViews = <Widget>[];
    listViews.add(_cardScreen(context));
    return Container(
      color: DashboardTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getAppBarUI(),
            getMainListViewUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  MediaQuery.of(context).size.height * (0.2),
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: DashboardTheme.white.withOpacity(0.0),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _founderIcon(topBarOpacity,
                                      widget.animationController)),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.height * 0.1,
                              child: Text(
                                "Founder's journey",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: DashboardTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  // letterSpacing: 0.3,
                                  color: DashboardTheme.lightText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

Widget _founderIcon(topBarOpacity, animationController) {
  return Row(children: <Widget>[
    AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return Transform(
            alignment: Alignment.topLeft,
            transform: Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0,
                (topBarOpacity == 1.0) ? 1.2 : 1),
            child: Align(
              alignment: Alignment.topLeft,
              child: CircleImage("assets/images/dashboard/founder.jpg"),
            ),
          );
        })
  ]);
}

class CircleImage extends StatelessWidget {
  String location;

  CircleImage(this.location);
  @override
  Widget build(BuildContext context) {
    double _size = MediaQuery.of(context).size.height * (1 / 4);

    return Center(
      child: new Container(
          width: _size,
          height: _size,
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                  fit: BoxFit.cover, image: Image.asset(location).image))),
    );
  }
}
