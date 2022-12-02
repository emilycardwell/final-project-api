
FROM python:3.10.8-buster

COPY setup.py /setup.py
COPY final-project/api final-project/api
COPY requirements_test.txt /requirements.txt

RUN pip install --upgrade pip
RUN pip install -e .

CMD uvicorn final-project.api.fast:app --host 0.0.0.0 --port $PORT
