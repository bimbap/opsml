FROM python:3.13-slim

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV FLASK_APP=app.py
ENV FLASK_SECRET_KEY=lks
ENV PYTHONUNBUFFERED=1

EXPOSE 2000

CMD [ "python", "app.py" ]
