import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gkfit/constants/keys.dart';

abstract class LoginPageEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

abstract class LoginPageState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoginPageLoadFirstTime extends LoginPageState {
  @override
  // TODO: implement props
  List<Object> get props => [true];
}

class LoginPageLoadNotFirstTime extends LoginPageState {
  @override
  // TODO: implement props
  List<Object> get props => [false];
}

class LoginPageLoadedFirstTimeCompleted extends LoginPageEvent {
  @override
  // TODO: implement props
  List<Object> get props => ["loaded"];
}

class LoginPageBloc extends Bloc<LoginPageEvent, LoginPageState> {
  @override
  // TODO: implement initialState
  LoginPageState get initialState => LoginPageLoadFirstTime();

  @override
  Stream<LoginPageState> mapEventToState(LoginPageEvent event) async* {
    if (event is LoginPageLoadedFirstTimeCompleted) {
      yield LoginPageLoadNotFirstTime();
    }
    // TODO: implement mapEventToState
    if (state is LoginPageLoadFirstTime) {
      if (!await checkWalkThroughScreen()) {
        yield LoginPageLoadNotFirstTime();
      }
    }
  }

  Future<bool> checkWalkThroughScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getBool(Keys.showWalkthrough) ?? true);
  }
}
