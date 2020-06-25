import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gkfit/bloc/login/login_bloc.dart';
import 'package:gkfit/constants/keys.dart';
import 'package:gkfit/repository/user_repository.dart';
import 'package:gkfit/screens/walk_through/walk_through_screen.dart';
import 'package:gkfit/widgets/loading/loadingIndicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkWalkThroughScreen(),
      builder:
          (BuildContext context, AsyncSnapshot<bool> showWalkThroughScreen) {
        if (showWalkThroughScreen.hasData) {
          if (showWalkThroughScreen.data) {
            return WalkThroughScreen();
          } else {
            return Scaffold(
              backgroundColor: Colors.white, //Colors.grey[200],
              body: BlocProvider<LoginBloc>(
                create: (context) => LoginBloc(),
                child: LoginForm(userRepository: _userRepository),
              ),
            );
          }
        } else {
          return LoadingIndicator();
        }
      },
    );
  }



  Future<bool> checkWalkThroughScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getBool(Keys.showWalkthrough) ?? true);
  }
}
