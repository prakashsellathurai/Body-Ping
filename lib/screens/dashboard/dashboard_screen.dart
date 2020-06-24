import 'dart:convert';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gkfit/bloc/user_bloc.dart';
import 'package:gkfit/model/userDataModel.dart';
import 'package:gkfit/provider/userDataProviderApiClient.dart';
import 'package:gkfit/screens/dashboard/founder/founder_screen.dart';
import 'package:gkfit/screens/dashboard/home/home_screen.dart';
import 'package:gkfit/screens/dashboard/your_wellness/your_wellness_screen.dart';
import 'package:flutter/rendering.dart';
import 'package:intercom_flutter/intercom_flutter.dart';

import './../../model/dashboard/tabIcon_data.dart';
import 'package:flutter/material.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import './dashboard_theme.dart';
import 'home/home_screen.dart';
import 'package:crypto/crypto.dart';
import './settings/settingsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppDashboardHomeScreen extends StatefulWidget {
  const AppDashboardHomeScreen({Key key, @required this.user, this.userData})
      : super(key: key);
  final FirebaseUser user;
  final UserDataModel userData;

  @override
  _AppDashboardHomeScreenState createState() {
    return _AppDashboardHomeScreenState._(user, userData);
  }
}

class _AppDashboardHomeScreenState extends State<AppDashboardHomeScreen>
    with TickerProviderStateMixin {
  UserBloc userBloc;

  _AppDashboardHomeScreenState._(this.user, this.userData);
  final FirebaseUser user;
  UserDataModel userData;
  bool showUserDetailsForm = true;
  AnimationController animationController;
  bool isScrollingDown = false;
  bool _show = true;
  ScrollController bottomBarScrollControl;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  UserDataProviderApiClient userDataApi = new UserDataProviderApiClient();

  Widget tabBody = Container(
    color: DashboardTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = false;
    bottomBarScrollControl = ScrollController();
    bottomBarScrollControl.addListener(() {
      bottomBarScrollControl.addListener(() {
        if (bottomBarScrollControl.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (!isScrollingDown) {
            isScrollingDown = true;
            hideBottomBar();
          }
        }
        if (bottomBarScrollControl.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (isScrollingDown) {
            isScrollingDown = false;

            showBottomBar();
          }
        }
      });
    });
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = DashboardHomeScreen(animationController: animationController);
    super.initState();
    initIntercom();
  }

  void showBottomBar() {
    setState(() {
      _show = true;
    });
  }

  void hideBottomBar() {
    setState(() {
      _show = false;
    });
  }

  @override
  void dispose() {
    bottomBarScrollControl.removeListener(() {});
    animationController.dispose();
    super.dispose();
  }

  Future<void> initIntercom() async {
    userBloc = BlocProvider.of<UserBloc>(context);
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
        name: userData.firstName,
        userId: userData.uid,
        phone: userData.phoneNumber,
        customAttributes: {
          "gender": userData.gender,
          "date of birth": userData.dateofbirth,
          "current_plan": userData.currentPlan,
          "firstName": userData.firstName,
          "lastName": userData.lastName
        });
    print(userUpdated);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DashboardTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            if (index == 0) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = DashboardHomeScreen(
                      animationController: animationController,
                      userData: userData);
                });
              });
            } else if (index == 1) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = YourWellness(
                      animationController: animationController,
                      userData: userData);
                });
              });
            } else if (index == 2) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      FounderScreen(animationController: animationController);
                });
              });
            } else if (index == 3) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = SettingsScreen(
                      animationController: animationController,
                      user: user,
                      userData: userData);
                });
              });
            }
          },
        ),
      ],
    );
  }
}
