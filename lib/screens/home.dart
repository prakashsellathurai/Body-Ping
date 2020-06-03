import 'package:gkfit/bloc/trackers/bmi/bmi_bloc.dart';
import 'package:gkfit/bloc/trackers/bmi/bmi_state.dart';
import 'package:gkfit/bloc/trackers/calorieIntake/CalorieIntakeBloc.dart';
import 'package:gkfit/bloc/trackers/calorieIntake/calorieIntakeState.dart';
import 'package:gkfit/bloc/trackers/water_intake/water_intake_bloc.dart';
import 'package:gkfit/bloc/trackers/water_intake/water_intake_state.dart';
import 'package:gkfit/bloc/home_bloc.dart';
import 'package:gkfit/bloc/user_bloc.dart';
import 'package:gkfit/model/userDataModel.dart';
import 'package:gkfit/provider/userDataProviderApiClient.dart';
import 'package:gkfit/screens/on_boarding/on_boarding_form_page.dart';
import 'package:gkfit/widgets/error/no_internet.dart';

import 'package:gkfit/widgets/loading/loadingIndicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './../services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  User user;
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
    user = Provider.of<User>(context);
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
      BuildContext context, User user, UserDataModel userdatemodel) {
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
