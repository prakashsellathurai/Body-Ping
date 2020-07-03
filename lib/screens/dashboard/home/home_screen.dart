import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gkfit/bloc/trackers/bmi/bmi_bloc.dart';
import 'package:gkfit/bloc/trackers/bmi/bmi_event.dart';
import 'package:gkfit/bloc/trackers/calorieIntake/CalorieIntakeBloc.dart';
import 'package:gkfit/bloc/trackers/calorieIntake/CalorieIntakeEvent.dart';
import 'package:gkfit/bloc/trackers/water_intake/water_intake_bloc.dart';
import 'package:gkfit/model/userDataModel.dart';
import 'package:gkfit/screens/dashboard/home/meals_list_view.dart';
import 'package:gkfit/screens/dashboard/home/set_reminder/set_reminder_screen.dart';
import 'package:gkfit/screens/dashboard/home/staticWaterView.dart';
import 'package:gkfit/screens/dashboard/home/trackers/bmi_tracker/bmi_tracker_home.dart';
import 'package:gkfit/screens/dashboard/home/trackers/calorie_tracker/calorie_tracker_home.dart';
import 'package:gkfit/screens/dashboard/home/trackers/water_tracker/water_tracker_home.dart';
import 'package:gkfit/screens/dashboard/ui_view/miniConsultWithExperts.dart';
import 'package:gkfit/widgets/animations/animated_rotated.dart';

import '../ui_view/body_measurement.dart';
import '../ui_view/glass_view.dart';
import '../ui_view/mediterranesn_diet_view.dart';
import '../ui_view/title_view.dart';
import '../dashboard_theme.dart';
import '../home/water_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'trackers/water_tracker/mini_water_intake_dashboard.dart';
import './trackers/calorie_tracker/CalorieIntakeMiniDahsboard.dart';
import 'package:gkfit/bloc/user_bloc.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class DashboardHomeScreen extends StatefulWidget {
  const DashboardHomeScreen({Key key, this.animationController, this.userData})
      : super(key: key);
  final UserDataModel userData;
  final AnimationController animationController;
  @override
  _DashboardHomeScreenState createState() =>
      _DashboardHomeScreenState(this.userData);
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  final ScrollController scrollController = ScrollController();
  UserBloc userBloc;
  double topBarOpacity = 0.0;
  DateTime currentDate;
  UserDataModel userData;
  WaterIntakeBloc waterIntakeBloc;
  AnimationController _rotateController;
  CalorieIntakeBloc calorieIntakeBloc;
  BmiBloc bmiBloc;
  var TopBarformatter = new DateFormat('MMMd');
  _DashboardHomeScreenState(this.userData);
  bool _isOnTop = true;
  bool showBackgroundImage = false;
  @override
  void initState() {
    _rotateController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 5000));
    _rotateController.repeat();
    userBloc = BlocProvider.of<UserBloc>(context);
    currentDate = DateTime.now();
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            showBackgroundImage = true;
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            showBackgroundImage = false;
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            showBackgroundImage = false;
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  _scrollToTop() {
    scrollController.animateTo(scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
    setState(() => _isOnTop = true);
  }

  _scrollToBottom() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 1000), curve: Curves.easeOut);
    setState(() => _isOnTop = false);
  }

  void addAllListData() {}

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    _rotateController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    calorieIntakeBloc = BlocProvider.of<CalorieIntakeBloc>(context);
    calorieIntakeBloc..add(FetchEntiredayMealModelEvent());

    bmiBloc = BlocProvider.of<BmiBloc>(context);
    bmiBloc..add(FetchBMI());

    userBloc = BlocProvider.of<UserBloc>(context);
    userBloc.fetchUser();
    return Container(
      color:
          showBackgroundImage ? DashboardTheme.background : Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            if (showBackgroundImage) ..._buildDecorations(),
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

  List<Widget> _buildDecorations() {
    final screenSize = MediaQuery.of(context).size;

    final pokeSize = screenSize.width * 0.548;

    return [
      Positioned(
        top: 0,
        left: -screenSize.height * 0.15,
        child: AnimatedRotation(
          animation: _rotateController,
          child: Image.asset(
            "assets/images/designs/pokeball.png",
            width: pokeSize,
            height: pokeSize,
            color: Colors.black.withOpacity(0.06),
          ),
        ),
      ),
      Positioned(
          top: screenSize.height * 0.5,
          right: -screenSize.width * 0.1,
          child: Transform.rotate(
            angle: -math.pi / 4,
            child: Image.asset(
              "assets/images/designs/dotted.png",
              width: screenSize.height * 0.1,
              height: screenSize.height * 0.1 * 0.54,
              color: Colors.black.withOpacity(0.3),
            ),
          )),
    ];
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          const int count = 9;
          List<Widget> listViews = <Widget>[];
          listViews.add(
            TitleView(
              titleTxt: 'Daily Nutrition',
              subTxt: 'Details',
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval((1 / count) * 0, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
              onclick: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        CalorietrackerHomeScreen()));
              },
            ),
          );
          listViews.add(
            CalorieIntakeMiniDashBoard(
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval((1 / count) * 1, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
              noInteraction: false,
            ),
          );
          listViews.add(
            JustTitleView(
              titleTxt: 'Track Your Meal',
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval((1 / count) * 0, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
              onclick: () {},
            ),
          );
          listViews.add(MealsListView(
            mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.animationController,
                    curve: Interval((1 / count) * 1, 1.0,
                        curve: Curves.fastOutSlowIn))),
            mainScreenAnimationController: widget.animationController,
          ));
          listViews.add(MiniConsultWithOurExpertsView(
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.animationController,
                    curve: Interval((1 / count) * 6, 1.0,
                        curve: Curves.fastOutSlowIn))),
            animationController: widget.animationController,
          ));
          listViews.add(
            TitleView(
              titleTxt: 'Water',
              subTxt: 'Details',
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval((1 / count) * 6, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
              onclick: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        WaterTrackerHomeScreen()));
              },
            ),
          );

          listViews.add(AnimatedBuilder(
              animation: widget.animationController,
              builder: (BuildContext context, Widget child) {
                return FadeTransition(
                    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.animationController,
                            curve: Interval((1 / count) * 6, 1.0,
                                curve: Curves.fastOutSlowIn))),
                    child: new Transform(
                        transform: new Matrix4.translationValues(
                            0.0,
                            30 *
                                (1.0 -
                                    Tween<double>(begin: 0.0, end: 1.0)
                                        .animate(CurvedAnimation(
                                            parent: widget.animationController,
                                            curve: Interval(
                                                (1 / count) * 6, 1.0,
                                                curve: Curves.fastOutSlowIn)))
                                        .value),
                            0.0),
                        child: WaterIntakeMiniDashboardView()));
              }));
          listViews.add(
            TitleView(
              titleTxt: 'Body measurement',
              subTxt: 'Today',
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval((1 / count) * 4, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
              onclick: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => BmitrackerHomeScreen()));
              },
            ),
          );

          listViews.add(GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => BmitrackerHomeScreen()));
            },
            child: BodyMeasurementView(
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval((1 / count) * 5, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
            ),
          ));
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
                                child: StreamBuilder<UserDataModel>(
                                  stream: Stream.value(
                                      userBloc.state.getUserData()),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<UserDataModel> snapshot) {
                                    try {
                                      return GestureDetector(
                                        onTap: () {
                                          //  _isOnTop ? _scrollToBottom() :
                                          _scrollToTop();
                                        },
                                        child: RichText(
                                          maxLines: 12,
                                          softWrap: false,
                                          textAlign: TextAlign.left,
                                          text: TextSpan(
                                              text: (snapshot.hasData)
                                                  ? 'Hi ${capitalize((snapshot.data.firstName != null) ? snapshot.data.firstName : "home")}'
                                                  : "Home",
                                              style: TextStyle(
                                                fontFamily:
                                                    DashboardTheme.fontName,
                                                fontWeight: FontWeight.w700,
                                                fontSize:
                                                    22 + 6 - 6 * topBarOpacity,
                                                // letterSpacing: 1.2,
                                                color:
                                                    DashboardTheme.darkerText,
                                              )),
                                        ),
                                      );
                                    } catch (e) {
                                      return RichText(
                                        maxLines: 12,
                                        softWrap: false,
                                        textAlign: TextAlign.left,
                                        text: TextSpan(
                                            text: "Home",
                                            style: TextStyle(
                                              fontFamily:
                                                  DashboardTheme.fontName,
                                              fontWeight: FontWeight.w700,
                                              fontSize:
                                                  22 + 6 - 6 * topBarOpacity,
                                              // letterSpacing: 1.2,
                                              color: DashboardTheme.darkerText,
                                            )),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {
                                  setState(() {
                                    currentDate = currentDate
                                        .subtract(new Duration(days: 1));
                                  });
                                },
                                child: Center(
                                    // child: Icon(
                                    //   Icons.keyboard_arrow_left,
                                    //   color: DashboardTheme.grey,
                                    // ),
                                    ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              child: Row(
                                children: <Widget>[
                                  // Padding(
                                  //   padding: const EdgeInsets.only(right: 8),
                                  //   child: Icon(
                                  //     Icons.calendar_today,
                                  //     color: DashboardTheme.grey,
                                  //     size: 18,
                                  //   ),
                                  // ),
                                  // Text(
                                  //   '${TopBarformatter.format(currentDate)}',
                                  //   textAlign: TextAlign.left,
                                  //   style: TextStyle(
                                  //     fontFamily: DashboardTheme.fontName,
                                  //     fontWeight: FontWeight.normal,
                                  //     fontSize: 18,
                                  //     letterSpacing: -0.2,
                                  //     color: DashboardTheme.darkerText,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {
                                  setState(() {
                                    currentDate =
                                        currentDate.add(new Duration(days: 1));
                                  });
                                },
                                child: Center(
                                    // child: Icon(
                                    //   Icons.keyboard_arrow_right,
                                    //   color: DashboardTheme.grey,
                                    // ),
                                    ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.alarm,
                                color: DashboardTheme.grey,
                                // size: 18,
                              ),
                              onPressed: () {
                                print("alarm");
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        SetRemainderScreen()));
                              },
                            )
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

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
