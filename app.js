const express = require('express');
const { Pool } = require('pg');
const app = express();
app.use(express.json());

// Database connection pool
const pool = new Pool({
  user: process.env.POSTGRES_USER,
  host: process.env.DATABASE_HOST,
  database: process.env.POSTGRES_DB,
  password: process.env.POSTGRES_PASSWORD,
  port: process.env.DATABASE_PORT,
});

// Health check
app.get('/health', (req, res) => res.send('OK'));

// Return demo data from PostgreSQL
app.get('/data', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM demo');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Failed to retrieve data' });
  }
});

app.listen(3000, () => {
  console.log('Server is running on port 3000');
});