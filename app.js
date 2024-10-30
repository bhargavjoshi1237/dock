// app.js
const express = require('express');
const { Pool } = require('pg');

const app = express();
const port = 3000;

// Configure the PostgreSQL connection pool
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'demo_db',
  password: '',
  port: 5432,
});

// Define the /data route
app.get('/data', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM demo_table');
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
