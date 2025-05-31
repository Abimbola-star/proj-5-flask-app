from flask import Flask, Response, render_template_string
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST, Gauge

app = Flask(__name__)

# Create metrics
REQUESTS = Counter('flask_app_requests_total', 'Total number of requests to the Flask app')
ACTIVE_USERS = Gauge('flask_app_active_users', 'Number of active users')

# Set some initial values
ACTIVE_USERS.set(5)  # Example value

@app.route('/')
def home():
    REQUESTS.inc()  # Increment the counter
    return render_template_string('''
    <!DOCTYPE html>
    <html>
    <head>
        <title>Flask Monitoring Dashboard</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 40px;
                line-height: 1.6;
            }
            h1 {
                color: #333;
            }
            .metrics-link {
                display: inline-block;
                margin-top: 20px;
                padding: 10px 15px;
                background-color: #4CAF50;
                color: white;
                text-decoration: none;
                border-radius: 4px;
            }
            .metrics-link:hover {
                background-color: #45a049;
            }
        </style>
    </head>
    <body>
        <h1>Flask Monitoring Dashboard</h1>
        <p>This is a simple Flask app with Prometheus metrics.</p>
        <a href="/metrics" class="metrics-link">View Prometheus Metrics</a>
    </body>
    </html>
    ''')

@app.route('/metrics')
def metrics():
    REQUESTS.inc()  # Increment the counter
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)