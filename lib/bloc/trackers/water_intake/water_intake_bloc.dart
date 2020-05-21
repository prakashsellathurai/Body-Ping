import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:gkfit/bloc/trackers/water_intake/water_intake_repository.dart';
import 'package:gkfit/bloc/trackers/water_intake/water_intake_state.dart';
import 'package:equatable/equatable.dart';

class WaterIntakeEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class UpdateWaterIntakeEvent extends WaterIntakeEvent {}

class FetchWaterIntakeEvent extends WaterIntakeEvent {}

class AddtwoFiftyMlevent extends WaterIntakeEvent {}

class SubtracttwoFiftyMlevent extends WaterIntakeEvent {}

class WaterIntakeBloc extends Bloc<WaterIntakeEvent, WaterIntakeState> {
  String uid;

  WaterIntakeBloc({this.uid});
  WaterIntakeRepository _waterIntakeRepository = WaterIntakeRepository();
  dispose() {
    // dispose objects
    super.close();
  }

  @override
  WaterIntakeState get initialState => UnWaterIntakeState(0);

  @override
  Stream<WaterIntakeState> mapEventToState(
    WaterIntakeEvent event,
  ) async* {
    final currentState = state;
    try {
      if (event is UpdateWaterIntakeEvent) {
        await _waterIntakeRepository.updateDailyWaterIntake(
            uid, currentState.getDay(), currentState.getCurrentQuantityInMl());
        yield InWaterIntakeState(currentState.version + 1,
            currentState.getCurrentQuantityInMl(), currentState.getDay());
      }
      if (event is FetchWaterIntakeEvent) {
        await _waterIntakeRepository.updateDailyWaterIntake(
            uid, currentState.getDay(), currentState.getCurrentQuantityInMl());
        yield InWaterIntakeState(currentState.version + 1,
            currentState.getCurrentQuantityInMl(), currentState.getDay());
      }
      if (event is AddtwoFiftyMlevent) {
                var update_value = (currentState.getCurrentQuantityInMl() + 250 >3800) ? 3800 : currentState.getCurrentQuantityInMl() + 250;
        yield InWaterIntakeState(currentState.version + 1,
            update_value, currentState.getDay());
      }
      if (event is SubtracttwoFiftyMlevent) {
        var update_value = (currentState.getCurrentQuantityInMl() - 250 < 0) ? 0 : currentState.getCurrentQuantityInMl() - 250;
        yield InWaterIntakeState(currentState.version + 1,
            update_value, currentState.getDay());
      }
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'WaterIntakeBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
