const client = require('prom-client');

const register = new client.Registry();

client.collectDefaultMetrics({
    register,
    prefix: 'stackflow_backend_',
});

const httpServerDurationMicroseconds = new client.Histogram({
    name: 'http_server_duration_microseconds',
    help: 'Duration of HTTP requests in microseconds',
    labelNames: ['method', 'route', 'code'],
    buckets: [0.1, 5, 15, 50, 100, 500],
});

register.registerMetric(httpServerDurationMicroseconds);

const metricsMiddleware = (req, res, next) => {
    const start = process.hrtime();
    res.on('finish', () => {
        const duration = process.hrtime(start);
        const durationInMicroseconds = duration[0] * 1000000 + duration[1] / 1000;
        httpServerDurationMicroseconds
            .labels(req.method, req.path, res.statusCode)
            .observe(durationInMicroseconds);
    });
    next();
};

module.exports = {
    register,
    metricsMiddleware,
};
