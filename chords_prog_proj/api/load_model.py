from tensorflow import keras
import os

def load_model_local(model_version):

    nm_model = f'model_{model_version}'
    root_path = os.path.dirname(os.path.dirname(__file__))
    model_path = os.path.join(root_path, 'models', nm_model)
    model = keras.models.load_model(model_path)

    return model
