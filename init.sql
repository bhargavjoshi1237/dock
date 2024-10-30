-- init.sql
CREATE DATABASE demo_db;

\c demo_db;

CREATE TABLE demo_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    description TEXT
);

INSERT INTO demo_table (name, description) VALUES 
('Item 1', 'This is the first demo item'),
('Item 2', 'This is the second demo item');
