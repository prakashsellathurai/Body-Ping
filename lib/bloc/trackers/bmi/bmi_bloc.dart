import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:gkfit/model/trackers/weight_tracker/weight_tracker_model.dart';
import 'package:gkfit/repository/weight_tracker_repository.dart';
import 'bmi_state.dart';
import 'bmi_event.dart';

class BmiBloc extends Bloc<BmiEvent, BmiState> {
  final String uid;
  WeightTrackerRepository _weightTrackerRepository = WeightTrackerRepository();

  BmiBloc({this.uid});
  @override
  BmiState get initialState => UnBmiState();

  @override
  Stream<BmiState> mapEventToState(
    BmiEvent event,
  ) async* {
    final currentState = state;
    try {
      if (currentState is UnBmiState) {
        List<WeightTrackerModel> latestWeightlist =
            await _weightTrackerRepository.getLatestWeightLog(uid);
        if (latestWeightlist.length == 0) {
          yield InBmiState(
              lastLoggedTime: 'not logged',
              bmi: 0,
              weight_in_kgs: 0,
              height_in_cm: 0,
              bodyfat: 0);
        } else {
          yield InBmiState(
              lastLoggedTime: latestWeightlist[0].time,
              bmi: latestWeightlist[0].bmi,
              weight_in_kgs: latestWeightlist[0].weight_in_kgs,
              height_in_cm: latestWeightlist[0].height_in_cm,
              bodyfat: latestWeightlist[0].bodyfat);
        }
      } else if (currentState is InBmiState) {
        if (event is FetchBMI) {
          developer.log(
            ' Fetching BMI ',
            name: 'BMIIntakeBloc',
          );
          List<WeightTrackerModel> latestWeightlist =
              await _weightTrackerRepository.getLatestWeightLog(uid);

          if (latestWeightlist.length == 0 || latestWeightlist[0].time == null || latestWeightlist[0].bmi == null) {

            yield currentState.copyWith(
                lastLoggedTime: 'not logged',
                bmi: double.parse('0'),
                weight_in_kgs: double.parse('0'),
                height_in_cm: double.parse('0'),
                bodyfat: double.parse('0'));
          } else {
            yield currentState.copyWith(
                lastLoggedTime: latestWeightlist[0].time,
                bmi: latestWeightlist[0].bmi,
                weight_in_kgs: latestWeightlist[0].weight_in_kgs,
                height_in_cm: latestWeightlist[0].height_in_cm,
                bodyfat: latestWeightlist[0].bodyfat);
          }
        } else if (event is AddBMI) {
          developer.log(
            ' Adding BMI ',
            name: 'BMIIntakeBloc',
          );
          yield currentState.copyWith(
              lastLoggedTime: event.lastLoggedTime,
              bmi: event.bmi,
              weight_in_kgs: event.weight_in_kgs,
              height_in_cm: event.height_in_cm,
              bodyfat: event.bodyfat);
        } else if (event is UpdateBMI) {
          developer.log(
            ' Updaing BMI '+currentState.lastLoggedTime.toString(),
            name: 'BMIIntakeBloc',
          );
          await _weightTrackerRepository.addMealLog(
              uid,
              currentState.lastLoggedTime,
              currentState.weight_in_kgs,
              currentState.bmi,
              currentState.height_in_cm,
              currentState.bodyfat);
          developer.log(' updated the meal in database', name: 'BMIIntakeBloc');
          yield currentState;
        }
      }
    } catch (_, stackTrace) {
      developer.log('$_', name: 'BmiBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
