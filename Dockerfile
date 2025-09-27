FROM python:3.11-slim

WORKDIR /app

RUN apt update
RUN apt install curl

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
