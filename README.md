# PlantCare AI — Smart Plant Monitoring System

## Author
Name: Shafqat Ullah
Role: AI / Flutter Developer  
Project Type: End-to-End Machine Learning + Mobile Application  
Status: Completed Portfolio Project  

---

## Project Overview

PlantCare AI is a full-stack AI-powered mobile application designed to monitor plant conditions and predict:

- Whether the plant needs water
- Plant health status (Healthy / Unhealthy)

The system uses an Artificial Neural Network (ANN) model trained on environmental parameters and exposes predictions through a FastAPI backend, which is consumed by a Flutter mobile application.

This project demonstrates the complete workflow of machine learning model training, backend deployment, and mobile application integration.

---

## System Architecture

Flutter Mobile App → Provider State Management → FastAPI Backend → ANN Model → Prediction Response

---

## Features

### Machine Learning
- Artificial Neural Network (ANN) based model
- Binary classification outputs
- Data preprocessing and outlier removal
- Feature scaling using StandardScaler
- Real-time inference support

### Backend (FastAPI)
- REST API for prediction
- Model loading and inference
- JSON request/response handling
- Scalable architecture for deployment

### Flutter Application
- Clean and responsive UI
- Provider state management
- Real-time API integration
- Loading and result handling
- Display of prediction confidence

---

## Dataset Features

The model is trained using the following features:

| Feature Name            | Description                     |
|------------------------|---------------------------------|
| Temperature_C          | Environmental temperature       |
| Humidity_%             | Air humidity level              |
| Soil_Moisture_%        | Soil water content              |
| Soil_pH                | Soil acidity/alkalinity level   |
| Nutrient_Level         | Soil nutrient availability      |
| Light_Intensity_lux    | Light exposure level            |

---

## Model Outputs

| Output Type     | Description                    |
|----------------|--------------------------------|
| Needs Water     | 0 = No, 1 = Yes                |
| Health Status   | 0 = Unhealthy, 1 = Healthy     |

---

## Machine Learning Pipeline

### Data Preprocessing
- Removal of Plant_ID column
- Clipping Soil_Moisture between 0 and 100
- Outlier removal using Z-score method
- Feature scaling using StandardScaler

### ANN Architecture

Input Layer (6 features)  
→ Dense Layer (32 neurons, ReLU)  
→ Dense Layer (16 neurons, ReLU)  
→ Dense Layer (8 neurons, ReLU)  
→ Output Layer 1: Water Prediction (Sigmoid)  
→ Output Layer 2: Health Prediction (Sigmoid)

---

## Backend Setup (FastAPI)

### Project Structure

backend/
├── app.py
├── plant_monitoring_model.h5
├── scaler.pkl
├── requirements.txt
├── dataset.csv
└── env/

---

### Installation

Create virtual environment:
python -m venv env

Activate environment:
env\Scripts\activate

Install dependencies:
pip install -r requirements.txt

---

### Run Server

uvicorn app:app --host 0.0.0.0 --port 8000 --reload

Server URL:
http://your-pc-ip address:8000
your mobile phone and computer system must be connected to same wifi

API Documentation:
http://127.0.0.1:8000/docs

---

### API Endpoint

POST /predict

Request Body:

{
  "Temperature_C": 28,
  "Humidity_": 70,
  "Soil_Moisture_": 25,
  "Soil_pH": 6.5,
  "Nutrient_Level": 45,
  "Light_Intensity_lux": 18000
}

Response:

{
  "needs_water": true,
  "health_status": "Healthy",
  "water_probability": 0.82,
  "health_probability": 0.91
}

---

## Flutter Application

### Project Structure

plant_app/
├── lib/
│   ├── models/
│   ├── provider/
│   ├── services/
│   ├── screens/
│   └── main.dart
├── android/
├── ios/
└── pubspec.yaml

---

### Run Application

flutter pub get
flutter run

---

## API Configuration

Android Emulator:
http://10.0.2.2:8000

Real Device:
http://YOUR_PC_IP:8000

Example:
http://192.168.100.143:8000

---

## Dependencies

### Backend
- FastAPI
- TensorFlow / Keras
- NumPy
- Pandas
- Scikit-learn
- Uvicorn
- Joblib

### Flutter
- provider
- http

---

## Future Improvements

- Plant disease detection using images
- IoT sensor integration for real-time data
- Cloud database integration
- Historical analytics dashboard
- Push notifications for watering alerts
- Mobile optimization improvements

---

## Learning Outcomes

This project demonstrates:

- Artificial Neural Network design and training
- Machine learning preprocessing techniques
- REST API development using FastAPI
- Flutter mobile application development
- Provider state management
- End-to-end AI system deployment

---

## Project Summary

This project represents a complete AI system lifecycle, from dataset processing and ANN training to backend deployment and mobile application integration. It demonstrates practical implementation of machine learning in a real-world mobile solution.
