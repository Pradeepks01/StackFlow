# Observability Documentation

## Stack
- **Prometheus**: Scrapes `/metrics` from the backend.
- **Grafana**: Visualizes metrics dashboards.
- **ELK**: Filebeat ships logs to Logstash -> Elasticsearch -> Kibana.
- **Jaeger**: Receives traces from OpenTelemetry collector.
