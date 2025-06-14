# Flask Application Monitoring Dashboard

This guide explains how to set up and use the Grafana dashboard for monitoring your Flask application.

## Dashboard Overview

The dashboard `flask_grafana_dashboard.json` provides comprehensive monitoring of your Flask application with the following panels:

### Application Overview
- **HTTP Request Rate**: Shows the rate of HTTP requests over time by method and status code
- **Total HTTP Requests**: Displays the total count of HTTP requests
- **HTTP Request Duration**: Shows the 95th and 50th percentile response times for endpoints
- **HTTP Requests by Status Code**: Pie chart showing the distribution of status codes

### System Resources
- **Memory Usage**: Tracks both resident and virtual memory usage
- **CPU Usage**: Monitors CPU utilization
- **Open File Descriptors**: Tracks the number of open file descriptors
- **Python GC Objects Collected**: Shows garbage collection metrics by generation

### Custom Application Metrics
- **Custom HTTP Requests by Endpoint**: Shows request rates by endpoint using your custom metrics

## Setup Instructions

1. **Install Grafana** (if not already installed)
   - Download from [Grafana website](https://grafana.com/grafana/download)
   - Or use Docker: `docker run -d -p 3000:3000 grafana/grafana`

2. **Configure Prometheus Data Source**
   - Log in to Grafana (default: admin/admin)
   - Go to Configuration > Data Sources
   - Add a new Prometheus data source
   - Set the URL to your Prometheus server (e.g., http://localhost:9090)
   - Save and test the connection

3. **Import the Dashboard**
   - Go to Dashboards > Import
   - Upload the `flask_grafana_dashboard.json` file or paste its contents
   - Select your Prometheus data source in the dropdown
   - Click Import

## Customizing the Dashboard

- **Time Range**: Adjust the time range in the top-right corner
- **Refresh Rate**: Set automatic refresh intervals as needed
- **Variables**: The dashboard uses a Prometheus data source variable that can be changed if needed
- **Add Panels**: You can add more panels to track additional metrics

### Changing Colors

1. **Edit Panel Colors**:
   - Click on any panel and select "Edit"
   - In the panel editor, go to the "Field" tab
   - Under "Standard options" or "Override", find the "Color scheme" option
   - Choose from preset color palettes or create custom colors
   - For single stats, you can set thresholds with different colors
   
   **Panel Background Color**:
   - While editing a panel, go to the "Panel options" tab
   - Find "Background" and click the color picker
   - Choose a custom color or set transparency

2. **Change Dashboard Theme and Background**:
   - Click the gear icon in the top-right corner
   - Select "Preferences"
   - Under "UI Theme", choose between Dark, Light, or Custom themes
   - For custom background colors, go to Dashboard settings (gear icon) > "JSON Model"
   - Find the "style" property and change it from "dark" or "light" to a custom JSON object:
     ```json
     "style": {
       "backgroundColor": "#1f1f1f",
       "color": "#FFFFFF"
     }
     ```

3. **Custom Color Palettes**:
   - For graphs, click "Edit" on a panel
   - Go to the "Field" tab
   - Under "Standard options", click "Color scheme"
   - Select "Custom" to define your own color palette
   - Add colors using hex codes or the color picker

4. **Threshold-Based Colors**:
   - Edit a panel and go to the "Field" tab
   - Find "Thresholds" and click to expand
   - Add threshold values and assign colors to different ranges
   - This works well for gauges, stats, and other single-value visualizations

## Metrics Explanation

- `flask_http_request_total`: Total number of HTTP requests
- `flask_http_request_duration_seconds`: HTTP request duration in seconds
- `process_resident_memory_bytes`: Resident memory usage
- `process_virtual_memory_bytes`: Virtual memory usage
- `process_cpu_seconds_total`: CPU usage in seconds
- `process_open_fds`: Number of open file descriptors
- `python_gc_objects_collected_total`: Python garbage collection metrics

## Alerting

To set up alerts:

1. Hover over any panel and click the Edit button
2. Go to the Alert tab
3. Configure alert conditions based on your requirements
4. Set notification channels (email, Slack, etc.)

## Troubleshooting

- If metrics aren't showing, verify that Prometheus is scraping your Flask application
- Check that the Prometheus data source is correctly configured in Grafana
- Ensure your Flask application is exposing metrics at the `/metrics` endpoint