const express = require('express');
const { Pool } = require('pg');
const app = express();
const port = process.env.PORT || 3000;

// Setup Postgres Connection Pool
const pool = new Pool({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'dbadmin',
    password: process.env.DB_PASSWORD || 'password',
    database: process.env.DB_NAME || 'appdb',
    port: process.env.DB_PORT || 5432,
});

// Health check endpoint required by the AWS Application Load Balancer
app.get('/health', (req, res) => {
    res.status(200).send('OK');
});

// Main Route
app.get('/', async (req, res) => {
    try {
        const result = await pool.query('SELECT NOW()');
        res.send(`Hello from the DevOps App! Database time is: ${result.rows[0].now}`);
    } catch (err) {
        console.error('Database connection error:', err);
        res.send('Hello from the DevOps App! (Database not connected yet)');
    }
});

app.listen(port, () => {
    console.log(`App listening at http://localhost:${port}`);
});