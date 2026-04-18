const { Pool } = require('pg');
const logger = require('../observability/logger');

const pool = new Pool({
    user: process.env.DB_USER || 'admin',
    host: process.env.DB_HOST || 'db',
    database: process.env.DB_NAME || 'stackflow',
    password: process.env.DB_PASSWORD || 'password',
    port: process.env.DB_PORT || 5432,
});

pool.on('connect', () => {
    logger.info('Connected to the database');
});

pool.on('error', (err) => {
    logger.error('Unexpected error on idle client', err);
    process.exit(-1);
});

module.exports = {
    query: (text, params) => pool.query(text, params),
};
