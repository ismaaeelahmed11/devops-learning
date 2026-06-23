from flask import Flask
import redis
import os

app = Flask(__name__)

redis_host = os.environ.get('REDIS_HOST', 'redis')
r = redis.Redis(host=redis_host, port=6379, decode_responses=True)

@app.route('/')
def hello():
    return "Welcome to the CoderCo Containers Challenge!"

@app.route('/count')
def count():
    visits = r.incr('visits')
    return f"This page has been visited {visits} times."

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)