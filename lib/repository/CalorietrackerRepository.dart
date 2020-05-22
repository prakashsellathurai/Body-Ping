import './../provider/calorie_tracker_provider.dart';

class CalorieTrackerRepository {
CalorieTrackerProvider  _calorieTrackerProvider = CalorieTrackerProvider();

Future<Map<String,dynamic>> getMealdata(uid,dateString) async {
String body =await  _calorieTrackerProvider.getMealdata(uid, dateString);
return Json.parse(body);

}

}