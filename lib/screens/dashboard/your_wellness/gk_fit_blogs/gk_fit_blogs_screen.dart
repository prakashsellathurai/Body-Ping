import 'package:cached_network_image/cached_network_image.dart';
import 'package:gkfit/bloc/founder_blog_post_bloc.dart';
import 'package:gkfit/bloc/gk_fit_blog_bloc.dart';
import 'package:gkfit/model/wordpressModel.dart';
import 'package:gkfit/screens/dashboard/dashboard_theme.dart';
import 'package:gkfit/screens/dashboard/founder/loading_blog_list.dart';
import 'package:gkfit/screens/dashboard/your_wellness/gk_fit_blogs/gk_fit_blog_post_screen.dart';
import 'package:gkfit/widgets/error/no_internet.dart';
import 'package:gkfit/widgets/ui/blog_list_loader.dart';
import 'package:gkfit/widgets/ui/blog_post_container.dart';
import 'package:gkfit/widgets/ui/overlayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pk_skeleton/pk_skeleton.dart';

class GKFITblogsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GKFITblogsScreenState();
}

class GKFITblogsScreenState extends State<GKFITblogsScreen> {
  final PageController controller = PageController(viewportFraction: 0.8);
  Stream slides;
  int currentPage = 0;
  GKFITBlogbloc gkfitblogbloc;

  @override
  void initState() {
    // TODO: implement initState
    gkfitblogbloc = GKFITBlogbloc();
    gkfitblogbloc.add(GKFITBlogFetch());

    controller.addListener(() {
      int next = controller.page.round();
      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    gkfitblogbloc.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(45),
            bottomRight: Radius.circular(45),
          )),
          centerTitle: true,
          title: Text(
            "GK FIT Blogs",
            style:
                Theme.of(context).textTheme.title.copyWith(color: Colors.black),
          ),
        ),
        backgroundColor: DashboardTheme.background,
        body: BlocBuilder<GKFITBlogbloc, GKFITBlogState>(
            bloc: gkfitblogbloc,
            builder: (BuildContext context, GKFITBlogState state) {
              if (state is GKFITBlogError) {
                return Container(child: Center(child: NoInternet()));
              }

              if (state is GKFITBlogLoaded) {
                if (!state.posts.isEmpty) {
                  return PageView.builder(
                      controller: controller,
                      itemCount: state.hasReachedMax
                          ? state.posts.length
                          : state.posts.length + 1,
                      itemBuilder: (context, i) {
                        if (i >= state.posts.length) {
                          bool active = i == currentPage;
                          if (state.hasReachedMax &&
                              i == state.posts.length + 1) {
                            SinglePost endpost =
                                SinglePost.fromEndErrorHandler({
                              "featuredImage":
                                  "https://i.picsum.photos/id/870/200/300.jpg?blur=2",
                              "title": "end of the blog",
                              "content": ""
                            });
                            return _buildStoryPage(endpost, active);
                          } else {
                            return _loadingStory(active,false);
                          }
                        } else {
                          bool active = i == currentPage;
                          if (i == state.posts.length - 1 &&
                              !state.hasReachedMax) {
                            print("loadmore");
                            gkfitblogbloc.add(GKFITBlogFetch());
                          }

                          return _buildStoryPage(state.posts[i], active);
                        }
                      });
                } else {
                  return Center(child: Text("no more posts"));
                }
              }
              if (state is GKFITBlogUninitialized) {
                return _loadingStory(true,true);
              }
              return BlogLisLoader(
                length: 3,
              );
            }));
  }

  Widget _loadingStory(bool active, bool isFirstLoading) {
    // Animated properties
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 100 : 200;
    final double left = isFirstLoading ? 30 : 0;
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: top, bottom: 50, right: 30,left:left),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
           image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider("https://i.picsum.photos/id/870/200/300.jpg"),
            ),
        boxShadow: [
          BoxShadow(
            color: Colors.black87,
            blurRadius: blur,
            offset: Offset(offset, offset),
          ),
        ],
      ),
      child: Center(
          child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          " Loading Please wait ...",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      )),
    );
  }

  Widget _buildStoryPage(SinglePost data, bool active) {
    // Animated properties
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 100 : 200;

    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GKFITblogPostScreen(postData: data),
            ),
          );
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOutQuint,
          margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(data.featuredImage),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black87,
                blurRadius: blur,
                offset: Offset(offset, offset),
              ),
            ],
          ),
          child: Center(
              child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              data.title,
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          )),
        ));
  }
}
