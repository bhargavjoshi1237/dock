// app.js
const express = require('express');
const { Pool } = require('pg');

const app = express();
const port = process.env.PORT || 3000;

// Configure PostgreSQL connection
const pool = new Pool({
  user: process.env.POSTGRES_USER || 'postgres',
  host: 'localhost',
  database: process.env.POSTGRES_DB || 'demo_db',
  password: process.env.POSTGRES_PASSWORD || 'password',
  port: 5432,
});

app.get('/data', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM demo_table');
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
