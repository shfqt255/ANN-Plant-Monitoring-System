import 'package:flutter/material.dart';
import 'package:plant_care/Model/plant_input_model.dart';
import 'package:plant_care/Service/api_service.dart';

class PlantProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool loading = false;

  String waterResult = "";
  String healthResult = "";

  double waterProb = 0.0;
  double healthProb = 0.0;

  Future<void> predictPlant(PlantInputModel model) async {
    loading = true;
    notifyListeners();

    try {
      final data = await _apiService.predictPlant(model);

      waterResult = data["needs_water"] ? "Needs Water" : "No Water";

      healthResult = data["health_status"];

      waterProb = data["water_probability"];
      healthProb = data["health_probability"];
    } catch (e) {
      waterResult = "Error";
      healthResult = e.toString();
    }

    loading = false;
    notifyListeners();
  }
}
