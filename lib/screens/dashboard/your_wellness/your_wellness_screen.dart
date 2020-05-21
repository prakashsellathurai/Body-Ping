import 'dart:convert';

import 'package:gkfit/bloc/gk_fit_blog_bloc.dart';
import 'package:gkfit/bloc/user_bloc.dart';
import 'package:gkfit/model/userDataModel.dart';
import 'package:gkfit/provider/wordpressProvider.dart';
import 'package:gkfit/screens/dashboard/ui_view/consult_with_dietitian.dart';

import 'package:gkfit/screens/dashboard/your_wellness/gk_fit_blogs/gk_fit_blogs_screen.dart';
import 'package:gkfit/widgets/animations/slide_transition_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intercom_flutter/intercom_flutter.dart';

import '../ui_view/area_list_view.dart';
import '../ui_view/running_view.dart';
import '../ui_view/title_view.dart';
import 'package:flutter/material.dart';

import '../dashboard_theme.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class YourWellness extends StatefulWidget {
  const YourWellness({Key key, this.animationController, this.userData})
      : super(key: key);

  final UserDataModel userData;
  final AnimationController animationController;
  @override
  _YourWellnessState createState() => _YourWellnessState();
}

class _YourWellnessState extends State<YourWellness>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  UserBloc userBloc;
  @override
  void initState() {
    userBloc = BlocProvider.of<UserBloc>(context);
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

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
    initIntercom();
    super.initState();
  }

  void addAllListData() {
    const int count = 5;

    // listViews.add(
    //   TitleView(
    //     titleTxt: 'Your program',
    //     subTxt: 'Details',
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController,
    //         curve:
    //             Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
    //     animationController: widget.animationController,
    //   ),
    // );

    listViews.add(
      ConsultWithOurDieticianView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
        onTap: () async {
          userBloc = BlocProvider.of<UserBloc>(context);
          var userData = userBloc.state.getUserData();
          dynamic userUpdated = await Intercom.updateUser(
              email: userData.email,
              name: userData.displayName,
              userId: userData.uid,
              phone: userData.phoneNumber,
              customAttributes: {
                "gender": userData.gender,
                "date of birth": userData.dateofbirth,
                "current_plan": userData.currentPlan
              });
          print(userUpdated);
          await Intercom.displayMessenger();
          print("messager opened");
        },
      ),
    );

    if (widget.userData.currentPlan != 'free') {
      listViews.add(
        RunningView(
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: widget.animationController,
                  curve: Interval((1 / count) * 3, 1.0,
                      curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController,
        ),
      );
    }
    listViews.add(
      TitleView(
        titleTxt: 'GK Fit Exclusive Blogs',
        subTxt: 'more',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
        onclick: () {
          Navigator.of(context).push(SlideLeftRoute(
              widget: BlocProvider(
                  create: (context) => GKFITBlogbloc()..add(GKFITBlogFetch()),
                  child: GKFITblogsScreen())));
        },
      ),
    );

    listViews.add(
      GkFitBlogListView(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController,
                curve: Interval((1 / count) * 5, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  Future<void> initIntercom() async {
    var userData = userBloc.state.getUserData();
    String uid = userData.uid;

    final userId = utf8.encode(uid);
    final secret = utf8.encode('gLX8EC-OJlsCCUUd5O355KBwN0x6YHCwVONgyTdf');

    final hmacSha256 = new Hmac(sha256, secret);
    final userIdHash = hmacSha256.convert(userId);
    print("HMAC digest as hex string: $userIdHash");
    dynamic userhash = await Intercom.setUserHash('$userIdHash');
    print(userhash);

    dynamic registere =
        await Intercom.registerIdentifiedUser(userId: uid, email: null);
    print(registere);

    dynamic userUpdated = await Intercom.updateUser(
        email: userData.email,
        name: userData.displayName,
        userId: userData.uid,
        phone: userData.phoneNumber,
        customAttributes: {
          "gender": userData.gender,
          "date of birth": userData.dateofbirth,
          "current_plan": userData.currentPlan
        });
    print(userUpdated);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DashboardTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
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
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
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
                    color: DashboardTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: DashboardTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
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
                                child: Text(
                                  'Your Wellness',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: DashboardTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: DashboardTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   height: 38,
                            //   width: 38,
                            //   child: InkWell(
                            //     highlightColor: Colors.transparent,
                            //     borderRadius: const BorderRadius.all(
                            //         Radius.circular(32.0)),
                            //     onTap: () {},
                            //     child: Center(
                            //       child: Icon(
                            //         Icons.keyboard_arrow_left,
                            //         color: DashboardTheme.grey,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              // child: Row(
                              //   children: <Widget>[
                              //     Padding(
                              //       padding: const EdgeInsets.only(right: 8),
                              //       child: Icon(
                              //         Icons.calendar_today,
                              //         color: DashboardTheme.grey,
                              //         size: 18,
                              //       ),
                              //     ),
                              //     Text(
                              //       '15 May',
                              //       textAlign: TextAlign.left,
                              //       style: TextStyle(
                              //         fontFamily: DashboardTheme.fontName,
                              //         fontWeight: FontWeight.normal,
                              //         fontSize: 18,
                              //         letterSpacing: -0.2,
                              //         color: DashboardTheme.darkerText,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ),
                            // SizedBox(
                            //   height: 38,
                            //   width: 38,
                            //   child: InkWell(
                            //     highlightColor: Colors.transparent,
                            //     borderRadius: const BorderRadius.all(
                            //         Radius.circular(32.0)),
                            //     onTap: () {},
                            //     child: Center(
                            //       child: Icon(
                            //         Icons.keyboard_arrow_right,
                            //         color: DashboardTheme.grey,
                            //       ),
                            //     ),
                            //   ),
                            // ),
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
