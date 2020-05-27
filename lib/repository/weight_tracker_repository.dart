import 'package:gkfit/model/trackers/weight_tracker/weight_tracker_model.dart';
import 'package:gkfit/provider/weight_tracker_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeightTrackerRepository {
  WeightTrackerProvider _weightTrackerProvider = WeightTrackerProvider();
  Future<void> addMealLog(
      uid, time, weight_in_kgs, bmi, height_in_cm, bodyfat) async {
    return await _weightTrackerProvider.addWeightLog(
        uid, time, weight_in_kgs, bmi, height_in_cm, bodyfat);
  }

  Future<List<WeightTrackerModel>> getLatestWeightLog(uid) async {
    String responseString = await _weightTrackerProvider.getlastLog(uid);
    List<WeightTrackerModel> listofweightmodel = [];
    if (json.decode(responseString)["results"].length > 0) {
      json.decode(responseString)["results"].forEach((el) {
        listofweightmodel.add(WeightTrackerModel.fromJson(el));
      });
    }
    return listofweightmodel;
  }

  Future<List<WeightTrackerModel>> getHistory(uid,start_date,end_date) async {
    String responseString = await _weightTrackerProvider.getBmiLog(uid,start_date,end_date);
    List<WeightTrackerModel> listofweightmodel = [];
    if (json.decode(responseString)["results"].length > 0) {
      json.decode(responseString)["results"].forEach((el) {
        listofweightmodel.add(WeightTrackerModel.fromJson(el));
      });
    }
    return listofweightmodel;
  }


  String getToday() =>
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toUtc()
          .toIso8601String();
}
