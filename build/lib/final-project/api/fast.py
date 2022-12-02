from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

import random

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

# from taxifare.ml_logic.registry import load_model
# app.state.model = load_model()

@app.get("/predict")
def predict(chords: str):
    i = random.randint(0,1)
    if i == 0:
        return {'The next chord is': 'C'}
    else:
        return {'The next chord is': 'G'}

# @app.get("/predict")
# def predict(pickup_datetime: datetime,  # 2013-07-06 17:18:00
#             pickup_longitude: float,    # -73.950655
#             pickup_latitude: float,     # 40.783282
#             dropoff_longitude: float,   # -73.984365
#             dropoff_latitude: float,    # 40.769802
#             passenger_count: int):      # 1
#     """
#     predict taxi fare api
#     """
#     from taxifare.ml_logic.preprocessor import preprocess_features
#     import pytz

#     eastern = pytz.timezone("US/Eastern")
#     localized_pickup_time = eastern.localize(pickup_datetime, is_dst=None)

#     dt_format = localized_pickup_time.astimezone(pytz.utc)
#     dt_format_fin = dt_format.strftime("%Y-%m-%d %H:%M:%S UTC")

#     X_pred = pd.DataFrame(dict(
#             key=["2013-07-06 17:18:00"],
#             pickup_datetime=dt_format_fin,
#             pickup_longitude=float(pickup_longitude),
#             pickup_latitude=float(pickup_latitude),
#             dropoff_longitude=float(dropoff_longitude),
#             dropoff_latitude=float(dropoff_latitude),
#             passenger_count=int(passenger_count)
#         ))

#     X_processed = preprocess_features(X_pred)

#     y_pred = app.state.model.predict(X_processed)

#     return {'fare_amount': round(float(y_pred), 2)}

@app.get("/")
def root():
    return  {'greeting': 'Hello'}
