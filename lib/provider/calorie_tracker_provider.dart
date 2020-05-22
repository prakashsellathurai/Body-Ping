import 'package:gkfit/model/trackers/Nutrition_database_model.dart';
import 'package:http/http.dart' as http;

class CalorieTrackerProvider {
  String baseUrl =
      'https://trackers-api-dot-hygieafit.el.r.appspot.com/trackers/v1/calories';

  Future<String> getMealdata(uid, dateString) async {
    http.Response result =
        await http.get(baseUrl + '/get/$uid?date=$dateString');
    return result.body;
  }

  Future<String> getMealdataBetweenDate(uid, start_date, end_date) async {
    http.Response result = await http
        .get(baseUrl + '/get/$uid?start_date=$start_date&end_date=$end_date');
    return result.body;
  }

  Future<String> add_breakfast(
      String uid,
      List<NutritionDatabaseModel> meal_list,
      List<double> calories_list,
      List<int> quantities_in_grams,
      double total_calories) async {
    http.Response result =
        await http.post(baseUrl + '/add/$uid/breakfast', body: {
      "meal_list": meal_list,
      "calories_list": calories_list,
      "quantities_in_grams": quantities_in_grams,
      "total_calories": total_calories
    });
    return result.body;
  }

  Future<String> add_morningSnack(
      String uid,
      List<NutritionDatabaseModel> meal_list,
      List<double> calories_list,
      List<int> quantities_in_grams,
      double total_calories) async {
    http.Response result =
        await http.post(baseUrl + '/add/$uid/morning_snack', body: {
      "meal_list": meal_list,
      "calories_list": calories_list,
      "quantities_in_grams": quantities_in_grams,
      "total_calories": total_calories
    });
    return result.body;
  }

  Future<String> add_lunch(
      String uid,
      List<NutritionDatabaseModel> meal_list,
      List<double> calories_list,
      List<int> quantities_in_grams,
      double total_calories) async {
    http.Response result = await http.post(baseUrl + '/add/$uid/lunch', body: {
      "meal_list": meal_list,
      "calories_list": calories_list,
      "quantities_in_grams": quantities_in_grams,
      "total_calories": total_calories
    });
    return result.body;
  }

  Future<String> add_evening_snack(
      String uid,
      List<NutritionDatabaseModel> meal_list,
      List<double> calories_list,
      List<int> quantities_in_grams,
      double total_calories) async {
    http.Response result =
        await http.post(baseUrl + '/add/$uid/evening_snack', body: {
      "meal_list": meal_list,
      "calories_list": calories_list,
      "quantities_in_grams": quantities_in_grams,
      "total_calories": total_calories
    });
    return result.body;
  }

  Future<String> add_dinner(
      String uid,
      List<NutritionDatabaseModel> meal_list,
      List<double> calories_list,
      List<int> quantities_in_grams,
      double total_calories) async {
    http.Response result =
        await http.post(baseUrl + '/add/$uid/evening_snack', body: {
      "meal_list": meal_list,
      "calories_list": calories_list,
      "quantities_in_grams": quantities_in_grams,
      "total_calories": total_calories
    });
    return result.body;
  }
}
