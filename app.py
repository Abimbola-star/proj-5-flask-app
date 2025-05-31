from flask import Flask, request
from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__)
metrics = PrometheusMetrics(app)

# Add some default metrics
metrics.info('app_info', 'Application info', version='1.0.0')

# Custom metrics
@metrics.counter('http_requests_total', 'Total HTTP Requests',
             labels={'endpoint': lambda: request.endpoint})
@app.route('/')
def dashboard():
    return '''
    <html>
    <head>
        <title>CEEYIT Dashboard</title>
        <style>
            body { font-family: Arial; background: #FEFEFE; text-align: center; margin-top: 100px; }
            h1 { color: #2A9D8F; }
            p { font-size: 18px; color: #264653; }
            .metrics-link { 
                display: inline-block; 
                margin-top: 20px; 
                padding: 10px 15px; 
                background-color: #4CAF50; 
                color: white; 
                text-decoration: none; 
                border-radius: 4px; 
            }
        </style>
    </head>
    <body>
        <h1>CEEYIT Monitoring Dashboard</h1>
        <p>Your DevOps metrics will be visualized here.</p>
        <p><a href="/metrics" class="metrics-link">View Prometheus Metrics</a></p>
    </body>
    </html>
    '''

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)