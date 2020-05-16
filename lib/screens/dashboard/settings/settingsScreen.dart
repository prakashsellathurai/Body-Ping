import 'dart:convert';

import 'package:customer_app/bloc/user_bloc.dart';

import 'package:customer_app/model/userDataModel.dart';
import 'package:customer_app/screens/dashboard/settings/edit_account/editAccountScreen.dart';
import 'package:customer_app/widgets/animations/slide_transition_routes.dart';
import 'package:customer_app/widgets/exceptions/platform_alert_dialog.dart';
import 'package:customer_app/widgets/exceptions/platform_exception_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import './../../../services/auth_service.dart';
import 'package:settings_ui/settings_ui.dart';
import '../dashboard_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import './../../../constants/strings.dart';
import 'package:international_phone_input/international_phone_input.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen(
      {Key key, this.animationController, this.user, this.userData})
      : super(key: key);
  final AnimationController animationController;
  final User user;
  final UserDataModel userData;
  @override
  _SettingsScreenState createState() => _SettingsScreenState(user, userData);
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  UserBloc userBloc;

  _SettingsScreenState(this.user, this.userData);

  final User user;
  UserDataModel userData;
  String phoneNumber = '';
  String phoneIsoCode = '+91';

  Animation<double> topBarAnimation;
  bool lockInBackground = true;

  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    userBloc = BlocProvider.of<UserBloc>(context);
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

  Future<void> _signOut(BuildContext context) async {
    try {
      final AuthService auth = Provider.of<AuthService>(context, listen: false);
      await auth.signOut();
    } on PlatformException catch (e) {
      await PlatformExceptionAlertDialog(
        title: Strings.logoutFailed,
        exception: e,
      ).show(context);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: Strings.logout,
      content: Strings.logoutAreYouSure,
      cancelActionText: Strings.cancel,
      defaultActionText: Strings.logout,
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    print((phoneNumber == null || phoneNumber == ''));
    print(phoneNumber == '');
    print(phoneNumber);
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }

  Future<void> _goToEditScreen(BuildContext context) {
    Navigator.of(context).push(SlideLeftRoute(
        widget: BlocProvider(
            create: (context) => userBloc,
            lazy: true,
            child: (EditAccountScreen(userData)))));
  }

  Future<void> _onClickPhonenumber(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                content: InternationalPhoneInput(
              onPhoneNumberChange: onPhoneNumberChange,
              initialPhoneNumber: phoneNumber,
              initialSelection: phoneIsoCode,
              enabledCountries: ['+91'],
              labelText: "Phone Number",
            )));
  }

  Future<void> _onClickName(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            content: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter your name',
                ),
                onSubmitted: (name) async {
                  Navigator.of(context).pop();
                }))).then((onSuccess) => {});
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
                                  'Settings',
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

  Widget getMainListViewUI() {
    return BlocBuilder<UserBloc, UserState>(
      bloc: userBloc,
      condition: (previous,current) {
        return true;
      },
      builder: (BuildContext context, UserState userState) {
        if (userState is UserUnitialized) {
          return const SizedBox();
        }
        if (userState is UserDataFetched) {
          userData = userState.userData;
          print(userData.displayName);
          List<Widget> listViews = <Widget>[];
          var formatter = new DateFormat('dd-MM-yyyy');
          listViews.add(
            SettingsSection(
              title: 'Account',
              tiles: [
                SettingsTile(
                  title: (userData.displayName == '')
                      ? 'Enter your Name'
                      : userData.displayName ?? 'Enter your Name',
                  leading: Icon(Icons.person),
                  onTap: () => _goToEditScreen(context),
                ),
                SettingsTile(
                  title: (userData.phoneNumber == '')
                      ? 'Enter your Phone number'
                      : userData.phoneNumber ?? 'Enter your Phone number',
                  leading: Icon(Icons.phone),
                  onTap: () => _goToEditScreen(context),
                ),
                SettingsTile(
                    title: (userData.email == '')
                        ? 'Email'
                        : userData.email ?? 'Email',
                    leading: Icon(Icons.email),
                    onTap: () => _goToEditScreen(context)),
                SettingsTile(
                    title:
                        (userData.gender == '') ? ' ' : userData.gender ?? ' ',
                    leading: Icon(Icons.person),
                    onTap: () => _goToEditScreen(context)),
                SettingsTile(
                  title: formatter.format(DateTime.parse(userData.dateofbirth)),
                  leading: Icon(Icons.calendar_today),
                  onTap: () => _goToEditScreen(context),
                ),
                SettingsTile(
                    title: 'Sign out',
                    leading: Icon(Icons.exit_to_app),
                    onTap: () => _confirmSignOut(context)),
              ],
            ),
          );
          listViews.add(SettingsSection(
            title: 'Plan',
            tiles: [
              SettingsTile(
                title: "Current Plan : ${userData.currentPlan}",
                leading: Icon(Icons.card_travel),
                onTap: () {},
              ),
            ],
          ));
          listViews.add(SettingsSection(
            title: 'Misc',
            tiles: [
              SettingsTile(
                  title: 'Terms of Service', leading: Icon(Icons.description)),
              SettingsTile(
                  title: 'Privacy Policy',
                  leading: Icon(Icons.collections_bookmark)),
            ],
          ));
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom + 24,
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

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    super.dispose();
  }
}
