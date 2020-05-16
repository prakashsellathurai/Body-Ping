import 'package:customer_app/bloc/founder_blog_post_bloc.dart';
import 'package:customer_app/screens/dashboard/founder/loading_blog_list.dart';
import 'package:customer_app/widgets/error/no_internet.dart';
import 'package:customer_app/widgets/ui/blog_list_loader.dart';
import 'package:customer_app/widgets/ui/blog_post_container.dart';
import 'package:customer_app/widgets/ui/overlayed_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ghost_content_api/flutter_ghost_content_api.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'blog_post.dart';

class FounderblogScreen extends StatefulWidget {
  @override
  _FounderblogScreenState createState() => _FounderblogScreenState();
}

class _FounderblogScreenState extends State<FounderblogScreen> {
  ScrollController _scrollController;
  FounderBlogPostBloc founderBlogBloc;
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    founderBlogBloc = BlocProvider.of<FounderBlogPostBloc>(context);
    founderBlogBloc.fetchLatestPosts();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= _scrollThreshold) {
        print("load more");
        founderBlogBloc.add(FounderBlogPostFetch());
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    founderBlogBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            "Founder's Blog",
            style:
                Theme.of(context).textTheme.title.copyWith(color: Colors.black),
          ),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildSlidingLatestPosts(),
              Expanded(child: _buildListViewPosts()),
            ]));
  }

  Widget _buildSlidingLatestPosts() {
    return StreamBuilder<PostsResponse>(
        stream: founderBlogBloc.latestBlogdata,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: MediaQuery.of(context).size.height * .35,
              margin: const EdgeInsets.symmetric(vertical: 15.0),
              child: PageView.builder(
                controller: PageController(viewportFraction: .76),
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.posts.length,
                itemBuilder: (context, i) => OverlayedContainer(
                  authorAvatar: "${snapshot.data.posts[i].featureImage}",
                  author: " ",
                  image: "${snapshot.data.posts[i].featureImage}",
                  title: "${snapshot.data.posts[i].title}",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BlogScreen(postData: snapshot.data.posts[i]),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return PKCardSkeleton(
              isCircularImage: false,
              isBottomLinesActive: true,
            );
          }
        });
  }

  Widget _buildListViewPosts() {
    return Container(
        child: Padding(
            padding: const EdgeInsets.all(9),
            child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Text(
                    "All Posts",
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                  BlocBuilder<FounderBlogPostBloc, FounderBlogPostState>(
                      builder:
                          (BuildContext context, FounderBlogPostState state) {
                    if (state is FounderBlogPostError) {
                      return Container(child: Center(child: NoInternet()));
                    }

                    if (state is FounderBlogPostLoaded) {
                      if (!state.posts.posts.isEmpty) {
                        return Expanded(
                            child: ListView.builder(
                                controller: _scrollController,
                                shrinkWrap: true,
                                itemCount: state.hasReachedMax
                                    ? state.posts.posts.length
                                    : state.posts.posts.length + 1,
                                itemBuilder: (context, i) {
                                  if (i >= state.posts.posts.length) {
                                    return BlogLisLoader(
                                      length: 2,
                                    );
                                  } else {
                                    return PostContainer(
                                        author: " ",
                                        image:  "${state.posts.posts[i].featureImage}",
                                        title: "${state.posts.posts[i].title}",
                                        onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BlogScreen(
                                                        postData: state
                                                            .posts.posts[i]),
                                              ),
                                            ));
                                  }
                                }));
                      } else {
                        return Container(
                            child: Center(child: Text("no more posts")));
                      }
                    }
                    if (state is FounderBlogPostUninitialized) {
                      return Expanded(
                          child: BlogLisLoader(
                        length: 2,
                      ));
                    }
                    return Expanded(
                        child: BlogLisLoader(
                      length: 2,
                    ));
                  }),
                ]))));
  }
}
