const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const { collectDefaultMetrics, register } = require('prom-client');
const logger = require('./observability/logger');
const { metricsMiddleware } = require('./observability/metrics');
const { startTracer } = require('./observability/tracer');
const correlationMiddleware = require('./observability/correlation');

dotenv.config();

// init tracing before anything else
startTracer();

collectDefaultMetrics({ prefix: 'stackflow_backend_' });

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());
app.use(correlationMiddleware);
app.use(metricsMiddleware);

app.get('/', (req, res) => {
  logger.info('Root endpoint hit', { correlationId: req.correlationId });
  res.json({ message: 'Welcome to StackFlow API', status: 'UP' });
});

app.get('/health', (req, res) => {
  res.json({ status: 'UP', timestamp: new Date().toISOString() });
});

app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});

// TODO: add actual CRUD routes for users and system_logs tables

app.listen(PORT, () => {
  logger.info(`Server is running on port ${PORT}`);
});

module.exports = app;
