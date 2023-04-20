from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from chords_prog_proj.api.load_model import load_model_local

import random
import numpy as np
import json

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

@app.get("/predict_baseline")
def predict_baseline(chords: str):
    i = random.randint(0,1)
    if i == 0:
        return {'The next chord is': 'C'}
    else:
        return {'The next chord is': 'G'}

model = load_model_local('v1')

@app.get("/predict")
def predict(input_chords: str,  #'G,B,F'
            ):
    """
    predict taxi fare api
    """
    input_chords = input_chords.split(",")

    # load json with tokenization dict
    with open("chords_prog_proj/api/chord_dict.json", "r") as json_file:
        chord_to_id = json.load(json_file)

    id_to_chord = {v: k for k, v in chord_to_id.items()}

    # convert inputs into tokenized and predict
    def get_predicted_chord(song):
        # Convert chords to numbers
        song_convert = [chord_to_id[chord] for chord in song]

        # Return an array of size vocab_size, with the probabilities
        pred = model.predict([song_convert], verbose=0)
        # Return the index of the highest probability
        pred_class = np.argmax(pred[0])
        # Turn the index into a chord
        pred_chord = id_to_chord[pred_class]

        return pred_chord

    predicted_chord = get_predicted_chord(input_chords)

    return {'predicted_chord': predicted_chord}


@app.get("/")
def root():
    return  {'greeting': 'Hello'}
