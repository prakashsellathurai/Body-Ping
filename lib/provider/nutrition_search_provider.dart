import 'package:http/http.dart' as http;

class NutritionSearchProvider {
  String baseUrl = 'https://trackers-api-dot-hygieafit.el.r.appspot.com/trackers/v1/calories/search';
  Future<String> DoSearch(term) async {
    http.Response result = await http.get(baseUrl+'?name=$term');
    print(result.body.toString());
    return result.body;
  }
}