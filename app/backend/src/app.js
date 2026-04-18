const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const { register, metricsMiddleware } = require('../observability/metrics');
const logger = require('../observability/logger');
const startTracer = require('../observability/tracer');
const correlationMiddleware = require('../observability/correlation');

dotenv.config();

// Initialize OpenTelemetry tracing before anything else
startTracer();

const app = express();
const port = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// Correlation ID Middleware — adds X-Correlation-ID to every request/response
app.use(correlationMiddleware);

// Prometheus Metrics Middleware
app.use(metricsMiddleware);

// Routes
app.get('/', (req, res) => {
  logger.info('Root endpoint hit', { correlationId: req.correlationId });
  res.json({ message: 'Welcome to StackFlow API', status: 'UP' });
});

app.get('/health', (req, res) => {
  res.json({ status: 'UP', timestamp: new Date().toISOString() });
});

app.get('/metrics', async (req, res) => {
  res.setHeader('Content-Type', register.contentType);
  res.send(await register.metrics());
});

// Error handling
app.use((err, req, res, next) => {
  logger.error(err.stack, { correlationId: req.correlationId });
  res.status(500).send('Something broke!');
});

app.listen(port, () => {
  logger.info(`Server is running on port ${port}`);
});
