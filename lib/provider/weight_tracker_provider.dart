import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'dart:convert';

class WeightTrackerProvider {
  String baseUrl =
      'url';

  Future<String> addWeightLog(
      uid, time, weight_in_kgs, bmi, height_in_cm, bodyfat) async {

    http.Response result = await http.post(baseUrl + '/add/$uid',
        body: json.encode({
          "time": time,
          "weight_in_kgs": weight_in_kgs,
          "bmi": bmi,
          "height_in_cm": height_in_cm,
          "bodyfat": bodyfat
        }), headers: {"content-type": "application/json"});
    return result.body;
  }

  Future<String> getBmiLog(uid, start_date, end_date) async {
    http.Response result = await http
        .get(baseUrl + '/get/$uid?start_date=$start_date&end_date=$end_date');
    return result.body;
  }
    Future<String> getlastLog(uid) async {
    http.Response result = await http
        .get(baseUrl + '/get/$uid/last');
    return result.body;
  }
}
