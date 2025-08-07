-- Campus Event Finder Database Setup Script
-- Run this script to create the database schema

-- Execute the schema creation and load sample data
\i schema.sql
\i sample_data.sql


-- Verify the setup
SELECT 'Database setup completed successfully!' AS status;

-- Show summary statistics
SELECT 
    'Users' as table_name, 
    COUNT(*) as record_count 
FROM user_account
UNION ALL
SELECT 
    'Events' as table_name, 
    COUNT(*) as record_count 
FROM event
UNION ALL
SELECT 
    'Venues' as table_name, 
    COUNT(*) as record_count 
FROM venue
UNION ALL
SELECT 
    'Categories' as table_name, 
    COUNT(*) as record_count 
FROM category
ORDER BY table_name;