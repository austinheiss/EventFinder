-- Insert Categories
INSERT INTO category (name, description) VALUES
('Engineering', 'College of Engineering & Applied Science related events'),
('Research', 'Seminars, symposiums and research presentations'),
('Career', 'Career fairs, employer info sessions, networking'),
('Innovation', 'Workshops and events focused on innovation & prototyping'),
('Social', 'Social gatherings for students, faculty and alumni'),
('Hackathon', 'Hackathons and coding competitions'),
('Community Service', 'Volunteer and outreach activities'),
('Sports', 'Athletic or recreation events');

-- Insert Venues
INSERT INTO venue (name, address, capacity, description) VALUES
('Engineering Research Center 4270', '2901 Woodside Dr, ERC 4th Floor', 150, 'Lecture room in the Engineering Research Center'),
('Mantei Center Auditorium', '2901 Woodside Dr, Mantei Center', 200, 'Auditorium with full A/V'),
('Rhodes Hall Lobby', '2855 Dr. Martin Luther King Jr Dr, Ground Floor', 120, 'Open lobby space suitable for expos'),
('Swift Hall 800', '2851 Woodside Dr, 8th Floor', 100, 'Classroom with projector and moveable desks'),
('UC Innovation Hub', '2900 Reading Rd, 1st Floor', 250, 'Large collaborative space for hackathons and demos'),
('Tangeman University Center Great Hall', '2766 UC Main St, Level 4', 500, 'Multi-purpose hall for large gatherings'),
('Old Chem 525', '2855 Dr. Martin Luther King Jr Dr, Room 525', 80, 'Traditional classroom'),
('Nippert Stadium Patio', '2700 Bearcat Way', 300, 'Outdoor patio overlooking the field'),
('Lindner College Hall 200', '2906 Woodside Dr, Room 200', 90, 'Lecture space in business college'),
('Scioto Hall Maker Space', 'Scioto Residence Hall, Lower Level', 60, 'Maker space with 3D printers & tools');

-- Insert Users
INSERT INTO user_account (username, email, first_name, last_name, password_hash, phone, year_in_school, major) VALUES
('jsmith23', 'john.smith@mail.uc.edu', 'John', 'Smith', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4o8l5B2r1O', '555-0101', 'Junior', 'Computer Science'),
('emilyd', 'emily.davis@mail.uc.edu', 'Emily', 'Davis', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4o8l5B2r2P', '555-0102', 'Senior', 'Business Administration'),
('mikew', 'mike.wilson@mail.uc.edu', 'Mike', 'Wilson', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4o8l5B2r3Q', '555-0103', 'Sophomore', 'Mechanical Engineering'),
('sarahj', 'sarah.johnson@mail.uc.edu', 'Sarah', 'Johnson', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4o8l5B2r4R', '555-0104', 'Freshman', 'Electrical Engineering'),
('alexb', 'alex.brown@mail.uc.edu', 'Alex', 'Brown', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4o8l5B2r5S', '555-0105', 'Graduate', 'Computer Engineering'),
('lisat', 'lisa.taylor@mail.uc.edu', 'Lisa', 'Taylor', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4o8l5B2r6T', '555-0106', 'Junior', 'Industrial Design'),
('davidm', 'david.miller@mail.uc.edu', 'David', 'Miller', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4o8l5B2r7U', '555-0107', 'Senior', 'Aerospace Engineering'),
('rachelt', 'rachel.thomas@mail.uc.edu', 'Rachel', 'Thomas', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4o8l5B2r8V', '555-0108', 'Sophomore', 'Biomedical Engineering'),
('chrisl', 'chris.lee@mail.uc.edu', 'Chris', 'Lee', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4o8l5B2r9W', '555-0109', 'Faculty', 'Computer Science'),
('jennag', 'jenna.garcia@mail.uc.edu', 'Jenna', 'Garcia', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4o8l5B2r0X', '555-0110', 'Junior', 'Marketing');

-- Insert Events
INSERT INTO event (
  title,
  description,
  event_datetime,
  end_datetime,
  venue_id,
  category_id,
  organizer_id,
  max_attendees,
  current_attendees,
  registration_deadline,
  is_public
) VALUES
('CEAS Career Fair 2025', 'Meet employers seeking UC engineering talent', CURRENT_TIMESTAMP + INTERVAL '3 days', CURRENT_TIMESTAMP + INTERVAL '3 days 6 hours', 6, 3, 9, 500, 120, CURRENT_TIMESTAMP + INTERVAL '2 days', TRUE),
('Senior Design Expo', 'Showcase of senior engineering capstone projects', CURRENT_TIMESTAMP + INTERVAL '5 days', CURRENT_TIMESTAMP + INTERVAL '5 days 4 hours', 1, 1, 3, 300, 80, CURRENT_TIMESTAMP + INTERVAL '4 days', TRUE),
('AI in Healthcare Seminar', 'Research talks on AI applications in healthcare', CURRENT_TIMESTAMP + INTERVAL '4 days', CURRENT_TIMESTAMP + INTERVAL '4 days 3 hours', 2, 2, 5, 150, 30, CURRENT_TIMESTAMP + INTERVAL '3 days', TRUE),
('Bearcat Hackathon', '24-hour hackathon tackling smart campus challenges', CURRENT_TIMESTAMP + INTERVAL '7 days', CURRENT_TIMESTAMP + INTERVAL '8 days', 5, 6, 1, 250, 100, CURRENT_TIMESTAMP + INTERVAL '6 days', TRUE),
('Intro to 3D Printing Workshop', 'Hands-on training in additive manufacturing', CURRENT_TIMESTAMP + INTERVAL '2 days', CURRENT_TIMESTAMP + INTERVAL '2 days 2 hours', 10, 4, 6, 40, 20, CURRENT_TIMESTAMP + INTERVAL '1 day', FALSE),
('Engineering Barbecue Social', 'Meet and mingle with fellow Bearcat engineers', CURRENT_TIMESTAMP + INTERVAL '6 days', CURRENT_TIMESTAMP + INTERVAL '6 days 3 hours', 8, 5, 2, 200, 60, CURRENT_TIMESTAMP + INTERVAL '5 days', TRUE),
('Electronics Recycling Drive', 'Community service - recycle old electronics responsibly', CURRENT_TIMESTAMP + INTERVAL '8 days', CURRENT_TIMESTAMP + INTERVAL '8 days 4 hours', 3, 7, 4, 80, 25, CURRENT_TIMESTAMP + INTERVAL '7 days', TRUE),
('Rocketry Club Launch Briefing', 'Pre-launch safety and design review', CURRENT_TIMESTAMP + INTERVAL '9 days', CURRENT_TIMESTAMP + INTERVAL '9 days 2 hours', 4, 1, 9, 100, 30, CURRENT_TIMESTAMP + INTERVAL '8 days', TRUE),
('Women in Engineering Panel', 'Discussion with alumnae about career pathways', CURRENT_TIMESTAMP + INTERVAL '10 days', CURRENT_TIMESTAMP + INTERVAL '10 days 2 hours', 2, 5, 8, 150, 70, CURRENT_TIMESTAMP + INTERVAL '9 days', TRUE),
('Adaptive Sports Engineering Showcase', 'Projects improving accessibility in sports', CURRENT_TIMESTAMP + INTERVAL '12 days', CURRENT_TIMESTAMP + INTERVAL '12 days 3 hours', 7, 8, 5, 100, 40, CURRENT_TIMESTAMP + INTERVAL '11 days', TRUE);
