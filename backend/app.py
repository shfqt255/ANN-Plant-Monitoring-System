from fastapi import FastAPI
from pydantic import BaseModel
import numpy as np
import joblib
import tensorflow as tf

# LOAD MODEL + SCALER
model = tf.keras.models.load_model("plant_monitoring_model.h5")
scaler = joblib.load("scaler.pkl")

app = FastAPI()

# INPUT FORMAT FROM FLUTTER
class PlantInput(BaseModel):
    Temperature_C: float
    Humidity_: float
    Soil_Moisture_: float
    Soil_pH: float
    Nutrient_Level: float
    Light_Intensity_lux: float

# HEALTH MAP (0/1)
health_map = {
    0: "Unhealthy",
    1: "Healthy"
}

# PREDICT ENDPOINT
@app.post("/predict")
def predict(data: PlantInput):

    # Convert input to numpy array
    input_data = np.array([[
        data.Temperature_C,
        data.Humidity_,
        data.Soil_Moisture_,
        data.Soil_pH,
        data.Nutrient_Level,
        data.Light_Intensity_lux
    ]])

    # Scale input
    input_scaled = scaler.transform(input_data)

    # Model prediction
    water_pred, health_pred = model.predict(input_scaled)

    # WATER RESULT
    water_prob = float(water_pred[0][0])
    needs_water = 1 if water_prob > 0.5 else 0

    # HEALTH RESULT (BINARY)
    health_prob = float(health_pred[0][0])
    health_class = 1 if health_prob > 0.5 else 0

    # RESPONSE
    return {
        "needs_water": bool(needs_water),
        "health_status": health_map[health_class],
        "water_probability": water_prob,
        "health_probability": health_prob
    }