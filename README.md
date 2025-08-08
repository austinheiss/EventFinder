# Campus Event Finder CLI

Interactive command-line tool built with Node.js for discovering, creating, and managing campus events stored in a PostgreSQL database.

## Features

- Register and authenticate users (passwords hashed with bcrypt).
- Browse upcoming events with category, venue, capacity, and time information.
- Create new categories, venues, and events on the fly.
- Join or leave events with automatic capacity enforcement.
- Fully normalized SQL schema with sample data and example queries.

## Quick Start

### 1. Install dependencies

```bash
npm install
```

### 2. Create a PostgreSQL database

```bash
psql -U postgres -c "CREATE DATABASE campus_event_finder;"
```

### 3. Initialize schema & sample data

Option A – run the all-in-one script:

```bash
psql -U postgres -d campus_event_finder -f setup.sql
```

Option B – run them separately:

```bash
psql -U postgres -d campus_event_finder -f schema.sql
psql -U postgres -d campus_event_finder -f sample_data.sql
```


### 4. Start the CLI

```bash
npm run cli
```

Follow the interactive prompts to register, log in, and start interacting with the database.

## Requirements

- Node.js ≥ 18
- PostgreSQL ≥ 12

---

Created with the assistance of AI tools.