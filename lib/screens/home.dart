import 'package:gkfit/bloc/trackers/bmi/bmi_bloc.dart';
import 'package:gkfit/bloc/trackers/bmi/bmi_state.dart';
import 'package:gkfit/bloc/trackers/calorieIntake/CalorieIntakeBloc.dart';
import 'package:gkfit/bloc/trackers/calorieIntake/calorieIntakeState.dart';
import 'package:gkfit/bloc/trackers/water_intake/water_intake_bloc.dart';
import 'package:gkfit/bloc/trackers/water_intake/water_intake_state.dart';
import 'package:gkfit/bloc/user_bloc.dart';
import 'package:gkfit/model/userDataModel.dart';
import 'package:gkfit/provider/userDataProviderApiClient.dart';
import 'package:gkfit/screens/on_boarding/on_boarding_form_page.dart';
import 'package:gkfit/screens/sign_in/sign_in_page.dart';
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
                if ((userState.userData.phoneNumber == null &&
                        userState.userData.dateofbirth == null) ||
                    ((userState.userData.phoneNumber == '') &&
                        (userState.userData.dateofbirth == ''))) {
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
    return BlocBuilder<WaterIntakeBloc, WaterIntakeState>(
        bloc: BlocProvider.of<WaterIntakeBloc>(context),
        builder: (context, waterIntakeState) {
          if (waterIntakeState is UnWaterIntakeState) {
            return Center(child: LoadingIndicator());
          } else if (waterIntakeState is InWaterIntakeState) {
            return BlocBuilder<CalorieIntakeBloc, CalorieIntakeState>(
                bloc: BlocProvider.of<CalorieIntakeBloc>(context),
                builder: (context, calorieIntakeState) {
                  if (calorieIntakeState is CalorieIntakeStateUninitialized) {
                    return Center(child: LoadingIndicator());
                  } else if (calorieIntakeState
                      is CalorieIntakeStateinitialized) {
                    return BlocBuilder<BmiBloc, BmiState>(
                        bloc: BlocProvider.of<BmiBloc>(context),
                        builder: (context, bmiState) {
                          if (bmiState is UnBmiState) {
                            return Center(child: LoadingIndicator());
                          } else if (bmiState is InBmiState) {
                            return AppDashboardHomeScreen(
                                user: user, userData: userdatemodel);
                          }
                          return Center(child: LoadingIndicator());
                        });
                  }
                  return Center(child: LoadingIndicator());
                });
          }
          return Center(child: LoadingIndicator());
        });
  }
}
