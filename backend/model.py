import pandas as pd
import numpy as np

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from scipy import stats


import tensorflow as tf
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Dense, Input

import joblib

# load data
df= pd.read_csv('plant_moniter_health_data.csv')
# drop Plant_ID column
df.drop('Plant_ID', axis=1, inplace=True)


# keep the volue of Soil_Moisture between 0 and 100 only
df['Soil_Moisture_%']= df['Soil_Moisture_%'].clip(lower=0, upper=100)


#calculate z-score for outlier removal
numeric_cols=[
    "Temperature_C",
    "Humidity_%",
    "Soil_Moisture_%",
    "Soil_pH",
    "Nutrient_Level",
    "Light_Intensity_lux"
]
z_scores=np.abs(stats.zscore(df[numeric_cols]))
df=df[(z_scores<3).all(axis=1)]

#Create Needs_water Column
df['Needs_water']= np.where(df['Soil_Moisture_%']<30,1,0)


# assign x and y
x=df[numeric_cols]
y_water=df['Needs_water']
y_health= df['Health_Status']

# split data into train and test for both water and health
stratify= y_water.astype(str) + "_" + y_health.astype(str)
x_train, x_test, y_water_train, y_water_test, y_health_train, y_health_test= train_test_split(x,y_water, y_health, test_size=0.2, random_state=42, stratify=stratify)

# Scale the features
scaler= StandardScaler()
x_train_scaled= scaler.fit_transform(x_train)
x_test_scaled= scaler.transform(x_test)
joblib.dump(scaler, 'scaler.pkl')


# Model Architecture
input_layer= Input(shape=(x_train_scaled.shape[1],))
hidden_layer1= Dense(32, activation='relu')(input_layer)
hidden_layer2= Dense(16, activation='relu')(hidden_layer1)
hidden_layer3= Dense(8, activation='relu')(hidden_layer2)

output_water= Dense(1, activation='sigmoid', name='water_output')(hidden_layer3)
output_health= Dense(1, activation='sigmoid', name='health_output')(hidden_layer3)

# build the model
model= Model(inputs=input_layer, outputs=[output_water, output_health])

# compile the model 
model.compile(optimizer='adam', loss={
    'water_output': 'binary_crossentropy',
    'health_output': 'binary_crossentropy',
}, metrics={
    'water_output': 'accuracy',
    'health_output': 'accuracy'
},
)

# train the model
history= model.fit(
    x_train_scaled, 
    {
        'water_output': y_water_train,
        'health_output': y_health_train
    },
    validation_data=(x_test_scaled, 
    {
        'water_output': y_water_test,
        'health_output': y_health_test
    }),
    epochs=200,
    batch_size=32,
    verbose=1
)


# save model
model.save('plant_monitoring_model.h5')
print("Model Saved!")

