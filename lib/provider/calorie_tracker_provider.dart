import 'package:gkfit/model/trackers/Nutrition_database_model.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'dart:convert';

class CalorieTrackerProvider {
  String baseUrl =
      'url';

  Future<String> getMealdata(uid, dateString) async {


    http.Response result =
        await http.get(baseUrl + '/get/$uid?date=$dateString');
    return result.body;
  }

  Future<String> getEntireHistory(uid) async {
    http.Response result = await http.get(baseUrl + '/get/$uid/all');
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
      List<double> quantities_in_grams,
      double total_calories) async {
    List<dynamic> meal_listJson = [];

    for (NutritionDatabaseModel item in meal_list) {
      meal_listJson.add(json.encode(item.toJson()));
    }
    var body = json.encode({
      "date": DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toUtc()
          .toIso8601String(),
      "meal_list": meal_listJson,
      "calories_list": calories_list,
      "quantities_in_grams": quantities_in_grams,
      "total_calories": total_calories
    });

    http.Response result = await http.post(baseUrl + '/add/$uid/breakfast',
        body: body, headers: {"content-type": "application/json"});
    return result.body;
  }

  Future<String> add_morningSnack(
      String uid,
      List<NutritionDatabaseModel> meal_list,
      List<double> calories_list,
      List<double> quantities_in_grams,
      double total_calories) async {
    List<dynamic> meal_listJson = [];
    for (NutritionDatabaseModel item in meal_list) {
      meal_listJson.add(json.encode(item.toJson()));
    }
    var body = json.encode({
         "date": DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toUtc()
          .toIso8601String(),
      "meal_list": meal_listJson,
      "calories_list": calories_list,
      "quantities_in_grams": quantities_in_grams,
      "total_calories": total_calories
    });
    http.Response result = await http.post(baseUrl + '/add/$uid/morning_snack',
        body: body, headers: {"content-type": "application/json"});
    return result.body;
  }

  Future<String> add_lunch(
      String uid,
      List<NutritionDatabaseModel> meal_list,
      List<double> calories_list,
      List<double> quantities_in_grams,
      double total_calories) async {
    List<dynamic> meal_listJson = [];
    for (NutritionDatabaseModel item in meal_list) {
      meal_listJson.add(json.encode(item.toJson()));
    }
    var body = json.encode({
         "date": DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toUtc()
          .toIso8601String(),
      "meal_list": meal_listJson,
      "calories_list": calories_list,
      "quantities_in_grams": quantities_in_grams,
      "total_calories": total_calories
    });
    http.Response result = await http.post(baseUrl + '/add/$uid/lunch',
        body: body, headers: {"content-type": "application/json"});
    return result.body;
  }

  Future<String> add_evening_snack(
      String uid,
      List<NutritionDatabaseModel> meal_list,
      List<double> calories_list,
      List<double> quantities_in_grams,
      double total_calories) async {
    List<dynamic> meal_listJson = [];
    for (NutritionDatabaseModel item in meal_list) {
      meal_listJson.add(json.encode(item.toJson()));
    }
    var body = json.encode({
         "date": DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toUtc()
          .toIso8601String(),
      "meal_list": meal_listJson,
      "calories_list": calories_list,
      "quantities_in_grams": quantities_in_grams,
      "total_calories": total_calories
    });
    http.Response result = await http.post(baseUrl + '/add/$uid/evening_snack',
        body: body, headers: {"content-type": "application/json"});
    return result.body;
  }

  Future<String> add_dinner(
      String uid,
      List<NutritionDatabaseModel> meal_list,
      List<double> calories_list,
      List<double> quantities_in_grams,
      double total_calories) async {
    List<dynamic> meal_listJson = [];
    for (NutritionDatabaseModel item in meal_list) {
      meal_listJson.add(json.encode(item.toJson()));
    }
    var body = json.encode({
         "date": DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toUtc()
          .toIso8601String(),
      "meal_list": meal_listJson,
      "calories_list": calories_list,
      "quantities_in_grams": quantities_in_grams,
      "total_calories": total_calories
    });
    http.Response result = await http.post(baseUrl + '/add/$uid/dinner',
        body: body, headers: {"content-type": "application/json"});
    return result.body;
  }
}
