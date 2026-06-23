FROM python:3.12-slim
WORKDIR /app
COPY . .
RUN pip install --break-system-packages flask-redis
EXPOSE 5000
CMD ["python", "app.py"]
