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
  Stream<CalorieIntakeState> mapEventToState(CalorieIntakeEvent event) async* {
    final currentState = state;
    // TODO: implement mapEventToState
    try {
      if (currentState is CalorieIntakeStateUninitialized) {
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
            print(event.totalCalories);
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
          ' Fetching the meal from database',
          name: 'CalorieIntakeBloc',
        );
        EntireDayMealModel entireDayMeal =
            await _calorieTrackerRepository.fetchMealdata(uid, getToday());
        developer.log(
          ' Fetched the meal',
          name: 'CalorieIntakeBloc',
        );
        developer.log(
          'breakfast' + entireDayMeal.breakfast.toJson().toString(),
          name: 'CalorieIntakeBloc',
        );
        developer.log(
          'morning snack' + entireDayMeal.morning_snack.toJson().toString(),
          name: 'CalorieIntakeBloc',
        );
        developer.log(
          'lunch' + entireDayMeal.lunch.toJson().toString(),
          name: 'CalorieIntakeBloc',
        );

        yield currentState.copyWith(
            date: entireDayMeal.date,
            breakfast: entireDayMeal.breakfast,
            morningSnack: entireDayMeal.morning_snack,
            lunch: entireDayMeal.lunch,
            eveningSnack: entireDayMeal.evening_snack,
            dinner: entireDayMeal.dinner);
      }
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'CalorieIntakeBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }

  dispose() {
    super.close();
  }

  String getToday() => DateTime(DateTime.now().day).toIso8601String();
}
