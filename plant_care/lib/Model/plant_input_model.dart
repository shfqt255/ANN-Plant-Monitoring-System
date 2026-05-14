class PlantInputModel {
  double temperature;
  double humidity;
  double soilMoisture;
  double soilPH;
  double nutrientLevel;
  double lightIntensity;

  PlantInputModel({
    required this.temperature,
    required this.humidity,
    required this.soilMoisture,
    required this.soilPH,
    required this.nutrientLevel,
    required this.lightIntensity,
  });

  Map<String, dynamic> toJson() {
    return {
      "Temperature_C": temperature,
      "Humidity_": humidity,
      "Soil_Moisture_": soilMoisture,
      "Soil_pH": soilPH,
      "Nutrient_Level": nutrientLevel,
      "Light_Intensity_lux": lightIntensity,
    };
  }
}
