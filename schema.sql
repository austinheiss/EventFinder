-- Campus Event Finder Database Schema (Simplified)
-- Exactly 4 tables: User, Event, Venue, Category

-- Drop tables if they exist (for clean recreation)
DROP TABLE IF EXISTS event CASCADE;
DROP TABLE IF EXISTS user_account CASCADE;
DROP TABLE IF EXISTS venue CASCADE;
DROP TABLE IF EXISTS category CASCADE;

-- Category table
CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Venue table
CREATE TABLE venue (
    venue_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    address TEXT,
    capacity INTEGER,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User table (named user_account to avoid reserved word conflicts)
CREATE TABLE user_account (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    year_in_school VARCHAR(20) CHECK (year_in_school IN ('Freshman', 'Sophomore', 'Junior', 'Senior', 'Graduate', 'Faculty', 'Staff')),
    major VARCHAR(100),
    attended_event_ids INTEGER[] DEFAULT '{}',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Event table (simplified - no separate attendance tracking)
CREATE TABLE event (
    event_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    event_datetime TIMESTAMP NOT NULL,
    end_datetime TIMESTAMP,
    venue_id INTEGER NOT NULL REFERENCES venue(venue_id) ON DELETE CASCADE,
    category_id INTEGER NOT NULL REFERENCES category(category_id) ON DELETE CASCADE,
    organizer_id INTEGER NOT NULL REFERENCES user_account(user_id) ON DELETE CASCADE,
    max_attendees INTEGER,
    current_attendees INTEGER DEFAULT 0,
    registration_deadline TIMESTAMP,
    is_public BOOLEAN DEFAULT TRUE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_event_time CHECK (end_datetime IS NULL OR end_datetime > event_datetime),
    CONSTRAINT valid_registration_deadline CHECK (registration_deadline IS NULL OR registration_deadline <= event_datetime),
    CONSTRAINT valid_attendee_count CHECK (current_attendees >= 0 AND (max_attendees IS NULL OR current_attendees <= max_attendees))
);

-- Indexes for better query performance
CREATE INDEX idx_event_datetime ON event(event_datetime);
CREATE INDEX idx_event_category ON event(category_id);
CREATE INDEX idx_event_venue ON event(venue_id);
CREATE INDEX idx_event_organizer ON event(organizer_id);
CREATE INDEX idx_user_email ON user_account(email);
CREATE INDEX idx_user_username ON user_account(username);

-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers to automatically update updated_at columns
CREATE TRIGGER update_user_updated_at BEFORE UPDATE ON user_account FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_event_updated_at BEFORE UPDATE ON event FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();