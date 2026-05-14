import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plant_care/Model/plant_input_model.dart';

class ApiService {
  static const String baseUrl = "http://192.168.100.143:8000";

  Future<Map<String, dynamic>> predictPlant(PlantInputModel model) async {
    final response = await http.post(
      Uri.parse("$baseUrl/predict"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to get prediction");
    }
  }
}
