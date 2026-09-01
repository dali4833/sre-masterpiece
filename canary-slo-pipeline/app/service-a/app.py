import os
import time
import random
import logging
from flask import Flask, jsonify, request
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
import requests
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
SERVICE_B_CALLS = Counter('service_b_calls_total', 'Total calls to service-b', ['status'])

app = Flask(__name__)

class ServiceBClient:
    def __init__(self):
        self.base_url = os.getenv('SERVICE_B_URL', 'http://service-b:8081')
        self.session = requests.Session()
        self.timeout = float(os.getenv('SERVICE_B_TIMEOUT', '2.0'))
    
    def get_data(self):
        """Call service-b with retry logic"""
        for attempt in range(3):
            try:
                response = self.session.get(
                    f"{self.base_url}/api/data",
                    timeout=self.timeout
                )
                response.raise_for_status()
                SERVICE_B_CALLS.labels(status='success').inc()
                return response.json()
            except requests.exceptions.RequestException as e:
                logger.warning("service_b_call_failed", attempt=attempt+1, error=str(e))
                SERVICE_B_CALLS.labels(status='error').inc()
                if attempt == 2:
                    raise
                time.sleep(0.1 * (attempt + 1))
    
    def get_health(self):
        """Check service-b health"""
        try:
            response = self.session.get(
                f"{self.base_url}/health",
                timeout=1.0
            )
            return response.status_code == 200
        except:
            return False

service_b_client = ServiceBClient()

@app.route('/')
def index():
    """Main endpoint that calls service-b"""
    start_time = time.time()
    request_id = request.headers.get('X-Request-ID', str(random.randint(100000, 999999)))
    
    # Simulate some processing
    time.sleep(random.uniform(0.01, 0.05))
    
    # Call service-b
    try:
        data_from_b = service_b_client.get_data()
        status = 'success'
        status_code = 200
        response_data = {
            'service': 'service-a',
            'version': os.getenv('APP_VERSION', 'v1'),
            'request_id': request_id,
            'data_from_service_b': data_from_b,
            'timestamp': time.time()
        }
    except Exception as e:
        logger.error("request_failed", request_id=request_id, error=str(e))
        status = 'error'
        status_code = 503
        response_data = {
            'service': 'service-a',
            'version': os.getenv('APP_VERSION', 'v1'),
            'request_id': request_id,
            'error': 'Service B unavailable',
            'timestamp': time.time()
        }
    
    # Record metrics
    duration = time.time() - start_time
    REQUEST_COUNT.labels(method=request.method, endpoint='/', status=status_code).inc()
    REQUEST_DURATION.labels(method=request.method, endpoint='/').observe(duration)
    
    return jsonify(response_data), status_code

@app.route('/health')
def health():
    """Health check endpoint"""
    service_b_healthy = service_b_client.get_health()
    status_code = 200 if service_b_healthy else 503
    
    health_data = {
        'status': 'healthy' if service_b_healthy else 'degraded',
        'service': 'service-a',
        'service_b': 'healthy' if service_b_healthy else 'unhealthy',
        'timestamp': time.time()
    }
    
    return jsonify(health_data), status_code

@app.route('/metrics')
def metrics():
    """Prometheus metrics endpoint"""
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}

@app.route('/version')
def version():
    """Version endpoint for canary verification"""
    return jsonify({
        'version': os.getenv('APP_VERSION', 'v1'),
        'build': os.getenv('BUILD_ID', 'local'),
        'commit': os.getenv('GIT_COMMIT', 'unknown')
    })

if __name__ == '__main__':
    port = int(os.getenv('PORT', '8080'))
    app.run(host='0.0.0.0', port=port)
