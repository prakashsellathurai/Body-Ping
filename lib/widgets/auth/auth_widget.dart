import 'package:gkfit/bloc/trackers/bmi/bmi_bloc.dart';
import 'package:gkfit/bloc/trackers/water_intake/water_intake_bloc.dart';
import 'package:gkfit/bloc/trackers/calorieIntake/CalorieIntakeBloc.dart';

import 'package:gkfit/bloc/trackers/calorieIntake/CalorieIntakeEvent.dart';
import 'package:gkfit/bloc/trackers/bmi/bmi_event.dart';
import 'package:gkfit/bloc/home_bloc.dart';
import 'package:gkfit/bloc/user_bloc.dart';
import 'package:gkfit/widgets/loading/loadingIndicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './../../screens/home.dart';
import './../../screens/sign_in/sign_in_page.dart';
import './../../services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key key, @required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<User> userSnapshot;

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      return userSnapshot.hasData
          ? _buildHomePage(context, userSnapshot)
          : SignInPageBuilder();
    }
    return Scaffold(
      body: Center(
        child: LoadingIndicator(),
      ),
    );
  }

  Widget _buildHomePage(
      BuildContext context, AsyncSnapshot<User> userSnapshot) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<UserBloc>(
            create: (context) =>
                UserBloc(uid: userSnapshot.data.uid)..add(UserFetch()),
          ),
          BlocProvider<WaterIntakeBloc>(
            create: (context) => WaterIntakeBloc(uid: userSnapshot.data.uid)
              ..add(FetchWaterIntakeEvent()),
          ),
          BlocProvider<CalorieIntakeBloc>(
            create: (context) => CalorieIntakeBloc(uid: userSnapshot.data.uid)
              ..add(FetchEntiredayMealModelEvent()),
          ),
          BlocProvider<BmiBloc>(
            create: (context) =>
                BmiBloc(uid: userSnapshot.data.uid)..add(FetchBMI()),
          ),
        ],
        child: MaterialApp(
            theme: ThemeData(primarySwatch: Colors.indigo),
            home: BlocProvider<HomeBloc>(
                create: (context) => HomeBloc(
                    userBloc: BlocProvider.of<UserBloc>(context),
                    bmiBloc: BlocProvider.of<BmiBloc>(context),
                    calorieIntakeBloc:
                        BlocProvider.of<CalorieIntakeBloc>(context),
                    waterIntakeBloc: BlocProvider.of<WaterIntakeBloc>(context))
                  ..add(HomeEvent.appStarted),
                child: MaterialApp(
                  theme: ThemeData(primarySwatch: Colors.indigo),
                  home: HomePage(),
                ))));
  }
}
