import 'dart:async';
import 'package:gkfit/bloc/user_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import './trackers/calorieIntake/CalorieIntakeBloc.dart';
import './trackers/calorieIntake/CalorieIntakeState.dart';
import './trackers/bmi/bmi_bloc.dart';
import './trackers/bmi/bmi_state.dart';
import './trackers/water_intake/water_intake_bloc.dart';
import './trackers/water_intake/water_intake_state.dart';

enum HomeEvent { appStarted, loaded }
enum HomeState { notLoaded, loaded }

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final CalorieIntakeBloc calorieIntakeBloc;
  final WaterIntakeBloc waterIntakeBloc;
  final BmiBloc bmiBloc;
  final UserBloc userBloc;

  StreamSubscription<bool> _blocsSubscription;

  HomeBloc({this.userBloc,this.calorieIntakeBloc, this.waterIntakeBloc, this.bmiBloc});

  HomeState get initialState => HomeState.notLoaded;

  @override
  Future<void> close() async {
    _blocsSubscription?.cancel();
    super.close();
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event == HomeEvent.appStarted) {

      _blocsSubscription = Rx.combineLatest4(
          Stream.value(calorieIntakeBloc.state),
          Stream.value(waterIntakeBloc),
          Stream.value(bmiBloc),
          Stream.value(userBloc),
          (a, b, c,d) =>
              a is CalorieIntakeStateinitialized &&
              b is WaterIntakeState &&
              c is InBmiState && 
              d is UserDataFetched
              ).listen((isHomeLoaded) => add(HomeEvent.loaded));
    } else if (event == HomeEvent.loaded) {
      yield HomeState.loaded;
    }
  }
}
