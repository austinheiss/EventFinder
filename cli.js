// Run: npm run cli

import inquirer from 'inquirer';
import pg from 'pg';
import bcrypt from 'bcryptjs';
import { format } from 'date-fns';

const { Pool } = pg;
const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT ? Number(process.env.DB_PORT) : 5432,
  database: process.env.DB_NAME || 'campus_event_finder',
  user: process.env.DB_USER || process.env.USER,
  password: process.env.DB_PASSWORD || undefined,
});

// Validation helpers
const notEmpty = (msg) => (v) => (v && v.trim() !== '' ? true : msg);
const emailValid = (msg) => (v) => /[^\s@]+@[^\s@]+\.[^\s@]+/.test(v) ? true : msg;
const dateTimeValid = (msg) => (v) => !isNaN(Date.parse(v)) ? true : msg;
const positiveIntOpt = (msg) => (v) => (v === '' || (Number.isInteger(Number(v)) && Number(v) > 0)) ? true : msg;
const positiveInt = (msg) => (v) => (Number.isInteger(Number(v)) && Number(v) > 0) ? true : msg;

async function registerUser() {
  const answers = await inquirer.prompt([
    { name: 'first_name', message: 'First name:', validate: notEmpty('First name is required') },
    { name: 'last_name', message: 'Last name:', validate: notEmpty('Last name is required') },
    { name: 'username', message: 'Username:', validate: notEmpty('Username is required') },
    { name: 'email', message: 'Email:', validate: emailValid('Invalid email') },
    { type: 'password', name: 'password', message: 'Password:', mask: '*', validate: notEmpty('Password is required') },
  ]);

  const { first_name, last_name, username, email, password } = answers;
  // Check if a user with this username or email already exists
  const existing = await pool.query(
    'SELECT 1 FROM user_account WHERE username=$1 OR email=$2',
    [username, email]
  );
  if (existing.rowCount > 0) {
    console.log('\n⚠️ Username or email already exists. Try logging in.');
    return null;
  }
  const password_hash = await bcrypt.hash(password, 10);
  // Create a new user and return the generated user_id and first_name
  const res = await pool.query(
    `INSERT INTO user_account (username, email, first_name, last_name, password_hash)
     VALUES ($1,$2,$3,$4,$5) RETURNING user_id, first_name`,
    [username, email, first_name, last_name, password_hash]
  );
  console.log(`\n✅ Registered successfully! Your user id is ${res.rows[0].user_id}`);
  return { user_id: res.rows[0].user_id, first_name };
}

async function loginUser() {
  const answers = await inquirer.prompt([
    { name: 'email', message: 'Email:', validate: emailValid('Invalid email') },
    { type: 'password', name: 'password', message: 'Password:', mask: '*', validate: notEmpty('Password is required') },
  ]);
  // Look up the user by email to retrieve hashed password and name
  const res = await pool.query(
    'SELECT user_id, password_hash, first_name FROM user_account WHERE email=$1',
    [answers.email]
  );
  if (res.rowCount === 0) {
    console.log('\n❌ Invalid credentials');
    return null;
  }
  const user = res.rows[0];
  const match = await bcrypt.compare(answers.password, user.password_hash);
  if (!match) {
    console.log('\n❌ Invalid credentials');
    return null;
  }
  console.log(`\n✅ Welcome back, ${user.first_name}!`);
  return { user_id: user.user_id, first_name: user.first_name };
}

async function listEvents() {
  // List all upcoming, active events with their category and venue, ordered by date then title
  const res = await pool.query(`
    SELECT e.event_id, e.title, e.event_datetime, c.name AS category, v.name AS venue,
           e.current_attendees, e.max_attendees
    FROM event e
    JOIN category c ON e.category_id = c.category_id
    JOIN venue v ON e.venue_id = v.venue_id
    WHERE e.event_datetime > CURRENT_TIMESTAMP AND e.is_active = TRUE
    ORDER BY e.event_datetime ASC, e.title ASC
  `);
  if (res.rowCount === 0) {
    console.log('\n(No upcoming events)');
    return;
  }
  console.log('\nUpcoming events');
  res.rows.forEach((row) => {
    console.log(
      `${row.event_id}. ${row.title} | ${format(row.event_datetime, 'yyyy-MM-dd HH:mm')} | ${row.category} | ${row.venue} | ${row.current_attendees}/${row.max_attendees ?? '∞'}`
    );
  });
}

// Helper to choose or create a category
async function chooseCategory() {
  // Load all categories to present as choices
  let res = await pool.query('SELECT category_id, name FROM category ORDER BY name');
  let choices = res.rows.map(r => ({ name: r.name, value: r.category_id }));
  choices.push({ name: '<Create new category>', value: '__new__' });
  if (choices.length === 1) choices = [{ name: '<Create new category>', value: '__new__' }];
  const { cat } = await inquirer.prompt({ type: 'list', name: 'cat', message: 'Select category', choices });
  if (cat === '__new__') {
    const { name, description } = await inquirer.prompt([
      { name: 'name', message: 'New category name:', validate: notEmpty('Name required') },
      { name: 'description', message: 'Description (optional):' },
    ]);
    // Create a new category and return its id
    const ins = await pool.query('INSERT INTO category (name, description) VALUES ($1,$2) RETURNING category_id', [name, description || null]);
    return ins.rows[0].category_id;
  }
  return cat;
}

// Helper to choose or create a venue
async function chooseVenue() {
  // Load all venues to present as choices
  let res = await pool.query('SELECT venue_id, name FROM venue ORDER BY name');
  let choices = res.rows.map(r => ({ name: r.name, value: r.venue_id }));
  choices.push({ name: '<Create new venue>', value: '__new__' });
  if (choices.length === 1) choices = [{ name: '<Create new venue>', value: '__new__' }];
  const { ven } = await inquirer.prompt({ type: 'list', name: 'ven', message: 'Select venue', choices });
  if (ven === '__new__') {
    const answers = await inquirer.prompt([
      { name: 'name', message: 'Venue name:', validate: notEmpty('Name required') },
      { name: 'address', message: 'Address (optional):' },
      { name: 'capacity', message: 'Capacity (blank for none):', validate: positiveIntOpt('Enter positive integer or blank') },
      { name: 'description', message: 'Description (optional):' },
    ]);
    // Create a new venue and return its id
    const ins = await pool.query('INSERT INTO venue (name, address, capacity, description) VALUES ($1,$2,$3,$4) RETURNING venue_id', [
      answers.name,
      answers.address || null,
      answers.capacity ? Number(answers.capacity) : null,
      answers.description || null,
    ]);
    return ins.rows[0].venue_id;
  }
  return ven;
}

async function createEvent(loggedIn) {
  const category_id = await chooseCategory();
  const venue_id = await chooseVenue();
  const answers = await inquirer.prompt([
    { name: 'title', message: 'Title:', validate: notEmpty('Title required') },
    { name: 'description', message: 'Description (optional):' },
    { name: 'event_datetime', message: 'Event date & time (YYYY-MM-DD HH:MM):', validate: dateTimeValid('Invalid date/time') },
    { name: 'max_attendees', message: 'Max attendees (blank for unlimited):', validate: positiveIntOpt('Enter a positive integer or leave blank') },
    { name: 'registration_deadline', message: 'Registration deadline (YYYY-MM-DD HH:MM, blank for none):', validate: (v)=> v===''|| dateTimeValid('Invalid date/time')(v) },
    { type: 'confirm', name: 'is_public', message: 'Public event?', default: true },
  ]);
  const {
    title,
    description,
    event_datetime,
    max_attendees,
    registration_deadline,
    is_public,
  } = answers;
  // Create a new event owned by the logged in user and return its id
  const res = await pool.query(
    `INSERT INTO event (title, description, event_datetime, venue_id, category_id, organizer_id, max_attendees, registration_deadline, is_public)
     VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING event_id`,
    [
      title,
      description || null,
      event_datetime,
      venue_id,
      category_id,
      loggedIn.user_id,
      max_attendees ? Number(max_attendees) : null,
      registration_deadline || null,
      is_public,
    ]
  );
  console.log(`\n✅ Event created with id ${res.rows[0].event_id}`);
}

async function joinOrLeaveEvent(loggedIn, action) {
  await listEvents();
  const { event_id } = await inquirer.prompt({ name: 'event_id', message: `${action} which event id?`, validate: positiveInt('Enter event id') });
  const client = await pool.connect();
  try {
    // Start a transaction to keep user and event changes consistent
    await client.query('BEGIN');
    // Ensure the attendee list array exists for this user (COALESCE)
    await client.query(
      `UPDATE user_account SET attended_event_ids = COALESCE(attended_event_ids, '{}') WHERE user_id=$1`,
      [loggedIn.user_id]
    );
    if (action === 'Join') {
      // Lock the event row and read capacity/deadline to validate join
      const evtRes = await client.query(
        'SELECT max_attendees, current_attendees, event_datetime, registration_deadline FROM event WHERE event_id=$1 FOR UPDATE',
        [event_id]
      );
      if (evtRes.rowCount === 0) throw new Error('Event not found');
      const evt = evtRes.rows[0];
      if (evt.registration_deadline && new Date(evt.registration_deadline) <= new Date()) throw new Error('Deadline passed');
      if (new Date(evt.event_datetime) <= new Date()) throw new Error('Event occurred');
      if (evt.max_attendees && evt.current_attendees >= evt.max_attendees) throw new Error('Full');
      // Add the event id to the user's attended_event_ids only if not already present
      const addRes = await client.query(
        `UPDATE user_account SET attended_event_ids = attended_event_ids || $2::int WHERE user_id=$1 AND NOT attended_event_ids @> ARRAY[$2]::int[]`,
        [loggedIn.user_id, event_id]
      );
      if (addRes.rowCount === 0) throw new Error('Already joined');
      // Increment the event's attendee count
      await client.query('UPDATE event SET current_attendees = current_attendees + 1 WHERE event_id=$1', [event_id]);
      await client.query('COMMIT');
      console.log('\n✅ Joined event');
    } else {
      // Remove the event id from the user's attended_event_ids array
      const removeRes = await client.query(
        `UPDATE user_account SET attended_event_ids = array_remove(attended_event_ids, $2::int) WHERE user_id=$1 RETURNING attended_event_ids`,
        [loggedIn.user_id, event_id]
      );
      if (removeRes.rowCount === 0) throw new Error('Not attending');
      // Decrement attendee count, not going below zero
      await client.query('UPDATE event SET current_attendees = GREATEST(current_attendees-1,0) WHERE event_id=$1', [event_id]);
      await client.query('COMMIT');
      console.log('\n✅ Left event');
    }
  } catch (err) {
    await client.query('ROLLBACK');
    console.log(`\n${action} failed: ${err.message}`);
  } finally {
    client.release();
  }
}

async function loggedInMenu(user) {
  let exit = false;
  while (!exit) {
    const { choice } = await inquirer.prompt({
      type: 'list',
      name: 'choice',
      message: `\nWhat would you like to do, ${user.first_name}?`,
      choices: ['List events', 'Create event', 'Join event', 'Leave event', 'Logout', 'Exit'],
    });
    switch (choice) {
      case 'List events':
        await listEvents();
        break;
      case 'Create event':
        await createEvent(user);
        break;
      case 'Join event':
        await joinOrLeaveEvent(user, 'Join');
        break;
      case 'Leave event':
        await joinOrLeaveEvent(user, 'Leave');
        break;
      case 'Logout':
        return; // back to auth menu
      case 'Exit':
        await pool.end();
        process.exit(0);
    }
  }
}

async function main() {
  console.log('🗓️  Welcome to Campus Event Finder CLI');
  while (true) {
    const { action } = await inquirer.prompt({
      type: 'list',
      name: 'action',
      message: '\nMain menu',
      choices: ['Register', 'Login', 'Exit'],
    });
    if (action === 'Register') {
      const user = await registerUser();
      if (user) await loggedInMenu(user);
    } else if (action === 'Login') {
      const user = await loginUser();
      if (user) await loggedInMenu(user);
    } else {
      await pool.end();
      process.exit(0);
    }
  }
}

main();
