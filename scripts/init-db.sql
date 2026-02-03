-- Database Initialization Script
-- This script runs automatically when the MySQL container starts for the first time

-- Create database if it doesn't exist (handled by docker-compose)
-- CREATE DATABASE IF NOT EXISTS farm_backend;

USE farm_backend;

-- Set timezone
SET time_zone = '+05:30';

-- Create indexes for better performance (will be created by JPA, but we can add extra ones)
-- Example: Add indexes on frequently queried fields after tables are created by JPA

-- Initialize default data
-- You can add default data here if needed

-- Log initialization
SELECT 'Database initialized successfully' AS status;
