import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gkfit/bloc/home_bloc.dart';
import 'package:gkfit/bloc/user_bloc.dart';
import 'package:gkfit/model/userDataModel.dart';
import 'package:gkfit/provider/userDataProviderApiClient.dart';
import 'package:gkfit/screens/on_boarding/on_boarding_form_page.dart';
import 'package:gkfit/widgets/error/no_internet.dart';
import 'package:gkfit/widgets/loading/loadingIndicator.dart';

import './../bloc/authentication/bloc.dart';
import './dashboard/dashboard_screen.dart';
UserDataProviderApiClient userdataApi = UserDataProviderApiClient();

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  UserBloc userBloc;
  FirebaseUser user;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<AuthenticationBloc>(context).state.user;
    userBloc = BlocProvider.of<UserBloc>(context);
    return _buildHomePage(context);
  }

  Widget _buildHomePage(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<UserBloc, UserState>(
            bloc: userBloc,
            builder: (BuildContext context, UserState userState) {
              if (userState is UserFetchError) {
                return Center(child: NoInternet());
              }
              if (userState is UserUnitialized) {
                return Center(child: LoadingIndicator());
              }
              if (userState is UserDataFetched) {
                if ((userState.userData.firstName == null &&
                        userState.userData.dateofbirth == null) ||
                    ((userState.userData.firstName == '') &&
                        (userState.userData.dateofbirth == '')) ||
                        ((userState.userData.lastName == '') &&
                        (userState.userData.lastName == null))
                        ) {
                  return OnBoardingFormPage(user: user);
                } else {
                  return _appDashboardBuilder(
                      context, user, userState.userData);
                }
              }

              return Center(child: LoadingIndicator());
            }));
  }

  Widget _appDashboardBuilder(
      BuildContext context, FirebaseUser user, UserDataModel userdatemodel) {
    return BlocBuilder<HomeBloc, HomeState>(
        bloc: BlocProvider.of<HomeBloc>(context),
        builder: (context, homeState) {

          if (homeState == HomeState.notLoaded) {
            return Center(child: LoadingIndicator());
          } else if (homeState == HomeState.loaded) {
            return AppDashboardHomeScreen(user: user, userData: userdatemodel);
          }
          return Center(child: LoadingIndicator());
        });
  }
}
