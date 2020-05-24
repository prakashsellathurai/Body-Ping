import './../provider/calorie_tracker_provider.dart';
import 'dart:convert';
import './../model/trackers/calorieTracker/entireDayMealModel.dart';

class CalorieTrackerRepository {
  CalorieTrackerProvider _calorieTrackerProvider = CalorieTrackerProvider();

  Future<EntireDayMealModel> fetchMealdata(
          String uid, String dateString) async  {
              String responseString = await _calorieTrackerProvider.getMealdata(uid, dateString);
              EntireDayMealModel entireDayMealModel = (json.decode(responseString)["results"].length > 0 ) 
              ? EntireDayMealModel.fromJson(json.decode(responseString)["results"][0]) :
               EntireDayMealModel.emptyModel();
              return  entireDayMealModel;
          }
   

  Future<List<Map<String, dynamic>>> fetchMealdataBetweenDates(
          String uid, String start_date, String end_date) async =>
      json.decode(await _calorieTrackerProvider.getMealdataBetweenDate(
          uid, start_date, end_date));

  Future<void> addbreakfast(
          uid, meal_list, calories_list, quantities_in_grams, total_calories) =>
      _calorieTrackerProvider.add_breakfast(
          uid, meal_list, calories_list, quantities_in_grams, total_calories);
  Future<void> addmorningSnack(
          uid, meal_list, calories_list, quantities_in_grams, total_calories) =>
      _calorieTrackerProvider.add_morningSnack(
          uid, meal_list, calories_list, quantities_in_grams, total_calories);
  Future<void> addLunch(
          uid, meal_list, calories_list, quantities_in_grams, total_calories) =>
      _calorieTrackerProvider.add_lunch(
          uid, meal_list, calories_list, quantities_in_grams, total_calories);
  Future<void> add_evening_snack(
          uid, meal_list, calories_list, quantities_in_grams, total_calories) =>
      _calorieTrackerProvider.add_evening_snack(
          uid, meal_list, calories_list, quantities_in_grams, total_calories);
  Future<void> add_dinner(
          uid, meal_list, calories_list, quantities_in_grams, total_calories) =>
      _calorieTrackerProvider.add_dinner(
          uid, meal_list, calories_list, quantities_in_grams, total_calories);
}
