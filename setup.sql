-- Campus Event Finder Database Setup Script
-- Run this script to create the database schema

-- Execute the schema creation and load sample data
\i schema.sql
\i sample_data.sql


-- Verify the setup
-- Simple message to confirm the script ran without error
SELECT 'Database setup completed successfully!' AS status;

-- Count records in each table to confirm data was loaded
SELECT 
    'Users' as table_name, 
    COUNT(*) as record_count 
FROM user_account
UNION ALL
-- Count of events
SELECT 
    'Events' as table_name, 
    COUNT(*) as record_count 
FROM event
UNION ALL
-- Count of venues
SELECT 
    'Venues' as table_name, 
    COUNT(*) as record_count 
FROM venue
UNION ALL
-- Count of categories
SELECT 
    'Categories' as table_name, 
    COUNT(*) as record_count 
FROM category
ORDER BY table_name;