import os
import time
import random
from flask import Flask, jsonify, request
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
import structlog

# Setup structured logging
structlog.configure(
    processors=[
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.JSONRenderer()
    ]
)
logger = structlog.get_logger()

# Prometheus metrics
REQUEST_COUNT = Counter('http_requests_total', 'Total HTTP requests', ['method', 'endpoint', 'status'])
REQUEST_DURATION = Histogram('http_request_duration_seconds', 'HTTP request duration', ['method', 'endpoint'])

app = Flask(__name__)

# Sample data
DATA = {
    'products': [
        {'id': 1, 'name': 'Laptop', 'price': 999.99},
        {'id': 2, 'name': 'Phone', 'price': 699.99},
        {'id': 3, 'name': 'Tablet', 'price': 399.99},
    ],
    'services': [
        {'id': 1, 'name': 'Cloud Storage', 'status': 'active'},
        {'id': 2, 'name': 'CDN', 'status': 'active'},
        {'id': 3, 'name': 'Database', 'status': 'active'},
    ]
}

@app.route('/')
def index():
    return jsonify({
        'service': 'service-b',
        'version': os.getenv('APP_VERSION', 'v1'),
        'message': 'Service B is running!'
    })

@app.route('/api/data')
def get_data():
    """Main data endpoint"""
    start_time = time.time()
    
    # Simulate processing
    time.sleep(random.uniform(0.005, 0.02))
    
    response_data = {
        'service': 'service-b',
        'version': os.getenv('APP_VERSION', 'v1'),
        'data': DATA,
        'timestamp': time.time()
    }
    
    # Record metrics
    duration = time.time() - start_time
    REQUEST_COUNT.labels(method=request.method, endpoint='/api/data', status=200).inc()
    REQUEST_DURATION.labels(method=request.method, endpoint='/api/data').observe(duration)
    
    return jsonify(response_data)

@app.route('/health')
def health():
    return jsonify({
        'status': 'healthy',
        'service': 'service-b',
        'version': os.getenv('APP_VERSION', 'v1'),
        'timestamp': time.time()
    })

@app.route('/metrics')
def metrics():
    """Prometheus metrics endpoint"""
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}

@app.route('/version')
def version():
    return jsonify({
        'version': os.getenv('APP_VERSION', 'v1'),
        'build': os.getenv('BUILD_ID', 'local'),
        'commit': os.getenv('GIT_COMMIT', 'unknown')
    })

if __name__ == '__main__':
    port = int(os.getenv('PORT', '8081'))
    app.run(host='0.0.0.0', port=port)
