import 'package:http/http.dart' as http;

class NutritionSearchProvider {
  String baseUrl = 'url';
  Future<String> DoSearch(term) async {
    http.Response result = await http.get(baseUrl+'?name=$term');
    return result.body;
  }
}