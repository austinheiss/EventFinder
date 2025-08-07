# Campus Event Finder – Detailed Setup Guide

This guide walks you through configuring the PostgreSQL database and running the interactive CLI locally.

---

## 1. Prerequisites

• **Node.js** 18 or newer  
• **npm** (bundled with Node)  
• **PostgreSQL** 12 or newer

---

## 2. Clone and install

```bash
git clone <your-repo-url>
cd EventFinder
npm install
```

---

## 3. Create the database

```bash
psql -U postgres <<SQL
CREATE DATABASE campus_event_finder;
-- Optional dedicated user:
-- CREATE USER event_admin WITH PASSWORD 'strong_password';
-- GRANT ALL PRIVILEGES ON DATABASE campus_event_finder TO event_admin;
SQL
```

---

## 4. Load schema & sample data

### One-liner

```bash
psql -U postgres -d campus_event_finder -f setup.sql
```

### Separate scripts

```bash
psql -U postgres -d campus_event_finder -f schema.sql
psql -U postgres -d campus_event_finder -f sample_data.sql
```

Verify tables were created:

```bash
psql -d campus_event_finder -c "\dt"
```

---

## 5. Configure environment variables

Create a `.env` file (if it doesn’t exist):

```env
# PostgreSQL connection
db_HOST=localhost
DB_PORT=5432
DB_NAME=campus_event_finder
DB_USER=postgres
```

*(The CLI falls back to local defaults if variables are missing.)*

---

## 6. Run the CLI

```bash
npm run cli
```

---

## Troubleshooting

### Resetting the database

```bash
psql -U postgres -d campus_event_finder -f setup.sql
```

### Common errors

| Symptom | Cause | Fix |
|---------|-------|-----|
| `password authentication failed` | Wrong env vars | Check `.env` values |
| `ECONNREFUSED` | PostgreSQL not running | Start/PostgreSQL service |
| `relation \"event\" does not exist` | Schema not loaded | Run `setup.sql` or `schema.sql` |

---