-- Crear bases de datos adicionales
CREATE DATABASE app1_db;
CREATE DATABASE app2_db;

-- Crear usuario para las aplicaciones (con permisos limitados)
CREATE USER app_user WITH PASSWORD 'password_para_apps';

-- Otorgar permisos
GRANT ALL PRIVILEGES ON DATABASE app1_db TO app_user;
GRANT ALL PRIVILEGES ON DATABASE app2_db TO app_user;

-- Conectar a app1_db y crear esquema de ejemplo
\c app1_db;

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar datos de prueba
INSERT INTO users (username, email) VALUES 
    ('admin', 'admin@example.com'),
    ('demo_user', 'demo@example.com');