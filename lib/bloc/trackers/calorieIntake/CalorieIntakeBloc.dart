import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gkfit/model/trackers/calorieTracker/breakfastModel.dart';
import 'package:gkfit/model/trackers/calorieTracker/dinnerModel.dart';
import 'package:gkfit/model/trackers/calorieTracker/entireDayMealModel.dart';
import 'package:gkfit/model/trackers/calorieTracker/eveningSnackNodel.dart';
import 'package:gkfit/model/trackers/calorieTracker/lunchModel.dart';
import 'package:gkfit/model/trackers/calorieTracker/morningSnackModel.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer' as developer;
import 'CalorieIntakeEvent.dart';
import 'calorieIntakeState.dart';
import 'package:gkfit/repository/CalorietrackerRepository.dart';

class CalorieIntakeBloc extends Bloc<CalorieIntakeEvent, CalorieIntakeState> {
  String uid;
  CalorieIntakeBloc({this.uid});
  CalorieTrackerRepository _calorieTrackerRepository =
      CalorieTrackerRepository();
  @override
  // TODO: implement initialState
  CalorieIntakeState get initialState => CalorieIntakeStateUninitialized(
      entireDayMeal: EntireDayMealModel.emptyModel());

  @override
  Future<void> close() {
    // TODO: implement close
    return super.close();
  }
  @override
  Stream<CalorieIntakeState> mapEventToState(CalorieIntakeEvent event) async* {
    final currentState = state;
    // TODO: implement mapEventToState
    try {
      if (currentState is CalorieIntakeStateUninitialized) {
        if (DateTime.parse(currentState.entireDayMeal.date).day !=
            DateTime.now().toUtc().day) {
          yield CalorieIntakeStateinitialized(
              entireDayMeal: EntireDayMealModel.emptyModel());
        }
        EntireDayMealModel entireDayMeal =
            await _calorieTrackerRepository.fetchMealdata(uid, getToday());
        yield CalorieIntakeStateinitialized(entireDayMeal: entireDayMeal);
      }

      if (event is AddBreakFastEvent &&
          currentState is CalorieIntakeStateinitialized) {
        developer.log(
          'breakfast' + event.meallist.toString(),
          name: 'Add Break fast Event',
        );
        yield currentState.copyWith(
            breakfast: BreakFastModel(
                calories_list: event.calories_list,
                meal_list: event.meallist,
                quantities_in_grams: event.mealListQuantity,
                total_calories: event.totalCalories),
            morningSnack: currentState.entireDayMeal.morning_snack,
            lunch: currentState.entireDayMeal.lunch,
            eveningSnack: currentState.entireDayMeal.evening_snack,
            dinner: currentState.entireDayMeal.dinner,
            date: getToday());
      }

      if (event is AddMorningSnack &&
          currentState is CalorieIntakeStateinitialized) {
        yield currentState.copyWith(
            breakfast: currentState.entireDayMeal.breakfast,
            morningSnack: MorningSnackModel(
                calories_list: event.calories_list,
                meal_list: event.meallist,
                quantities_in_grams: event.mealListQuantity,
                total_calories: event.totalCalories),
            lunch: currentState.entireDayMeal.lunch,
            eveningSnack: currentState.entireDayMeal.evening_snack,
            dinner: currentState.entireDayMeal.dinner,
            date: getToday());
      }

      if (event is AddLunch && currentState is CalorieIntakeStateinitialized) {
        yield currentState.copyWith(
            breakfast: currentState.entireDayMeal.breakfast,
            morningSnack: currentState.entireDayMeal.morning_snack,
            lunch: LunchModel(
                calories_list: event.calories_list,
                meal_list: event.meallist,
                quantities_in_grams: event.mealListQuantity,
                total_calories: event.totalCalories),
            eveningSnack: currentState.entireDayMeal.evening_snack,
            dinner: currentState.entireDayMeal.dinner,
            date: getToday());
      }

      if (event is AddEveningSnack &&
          currentState is CalorieIntakeStateinitialized) {
        yield currentState.copyWith(
            breakfast: currentState.entireDayMeal.breakfast,
            morningSnack: currentState.entireDayMeal.morning_snack,
            eveningSnack: EveningSnackModel(
                calories_list: event.calories_list,
                meal_list: event.meallist,
                quantities_in_grams: event.mealListQuantity,
                total_calories: event.totalCalories),
            lunch: currentState.entireDayMeal.lunch,
            dinner: currentState.entireDayMeal.dinner,
            date: getToday());
      }

      if (event is AddDinner && currentState is CalorieIntakeStateinitialized) {
        yield currentState.copyWith(
            breakfast: currentState.entireDayMeal.breakfast,
            morningSnack: currentState.entireDayMeal.morning_snack,
            lunch: currentState.entireDayMeal.lunch,
            eveningSnack: currentState.entireDayMeal.evening_snack,
            date: getToday(),
            dinner: DinnerModel(
                calories_list: event.calories_list,
                meal_list: event.meallist,
                quantities_in_grams: event.mealListQuantity,
                total_calories: event.totalCalories));
      }

      if (event is UpdateDinnerModelIndatabaseEvent &&
          currentState is CalorieIntakeStateinitialized) {
        await _calorieTrackerRepository.add_dinner(
            uid,
            currentState.entireDayMeal.dinner.meal_list,
            currentState.entireDayMeal.dinner.calories_list,
            currentState.entireDayMeal.dinner.quantities_in_grams,
            currentState.entireDayMeal.dinner.total_calories);
        yield currentState;
      }
      if (event is UpdateEveneingMealModelIndatabaseEvent &&
          currentState is CalorieIntakeStateinitialized) {
        await _calorieTrackerRepository.add_evening_snack(
            uid,
            currentState.entireDayMeal.evening_snack.meal_list,
            currentState.entireDayMeal.evening_snack.calories_list,
            currentState.entireDayMeal.evening_snack.quantities_in_grams,
            currentState.entireDayMeal.evening_snack.total_calories);
        yield currentState;
      }
      if (event is UpdateLunchlModelIndatabaseEvent &&
          currentState is CalorieIntakeStateinitialized) {
        await _calorieTrackerRepository.addLunch(
            uid,
            currentState.entireDayMeal.lunch.meal_list,
            currentState.entireDayMeal.lunch.calories_list,
            currentState.entireDayMeal.lunch.quantities_in_grams,
            currentState.entireDayMeal.lunch.total_calories);
        yield currentState;
      }
      if (event is UpdateMorningSnackModelIndatabaseEvent &&
          currentState is CalorieIntakeStateinitialized) {
        await _calorieTrackerRepository.addmorningSnack(
            uid,
            currentState.entireDayMeal.morning_snack.meal_list,
            currentState.entireDayMeal.morning_snack.calories_list,
            currentState.entireDayMeal.morning_snack.quantities_in_grams,
            currentState.entireDayMeal.morning_snack.total_calories);
        yield currentState;
      }
      if (event is UpdateBreakfastModelIndatabaseEvent &&
          currentState is CalorieIntakeStateinitialized) {
        await _calorieTrackerRepository.addbreakfast(
            uid,
            currentState.entireDayMeal.breakfast.meal_list,
            currentState.entireDayMeal.breakfast.calories_list,
            currentState.entireDayMeal.breakfast.quantities_in_grams,
            currentState.entireDayMeal.breakfast.total_calories);
        yield currentState;
      }
      // if (event is UpdateEntiredayMealModelIndatabaseEvent) {}
      if (event is FetchEntiredayMealModelEvent &&
          currentState is CalorieIntakeStateinitialized) {
        developer.log(
          ' triggering fetch event ' +
            DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day) .toUtc().toString(),
          name: 'CalorieIntakeBloc',
        );

        if (DateTime.parse(currentState.entireDayMeal.date).toLocal().day !=
            (DateTime.parse(getToday()).toLocal().day)) {
          developer.log(
            'Resetting Calorie local State  ',
            name: 'CalorieIntakeBloc',
          );
          EntireDayMealModel _emptyMeal = EntireDayMealModel.emptyModel();

          yield currentState.copyWith(
              breakfast: _emptyMeal.breakfast,
              morningSnack: _emptyMeal.morning_snack,
              lunch: _emptyMeal.lunch,
              eveningSnack: _emptyMeal.evening_snack,
              dinner: _emptyMeal.dinner,
              date: _emptyMeal.date);
        } else {
          developer.log(
            ' Fetching the meal from database ' +
                (DateTime.parse(currentState.entireDayMeal.date)
                    .toUtc()
                    .day
                    .toString()),
            name: 'CalorieIntakeBloc',
          );

          EntireDayMealModel _updatedEntireDayMeal =
              await _calorieTrackerRepository.fetchMealdata(uid, getToday());
          developer.log(
            ' Fetched the meal ' +
                currentState.entireDayMeal.date +
                ' ' +
                _updatedEntireDayMeal.date.toString() +
                ' ' +
                getToday(),
            name: 'CalorieIntakeBloc',
          );

          yield currentState.copyWith(
              date: _updatedEntireDayMeal.date,
              breakfast: _updatedEntireDayMeal.breakfast,
              morningSnack: _updatedEntireDayMeal.morning_snack,
              lunch: _updatedEntireDayMeal.lunch,
              eveningSnack: _updatedEntireDayMeal.evening_snack,
              dinner: _updatedEntireDayMeal.dinner);
        }
      }
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'CalorieIntakeBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }

  String getToday() =>
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toUtc()
          .toIso8601String();
}
