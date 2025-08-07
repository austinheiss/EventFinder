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
DB_PASSWORD=your_password   # omit if not needed
```

*(The CLI falls back to local defaults if variables are missing.)*

---

## 6. Run the CLI

```bash
npm run cli
```

### Main menu

• **Register** – create a new user  
• **Login** – authenticate and open the logged-in menu  
• **Exit** – quit the program

### Logged-in menu

• **List events** – view upcoming events  
• **Create event** – add a new event  
• **Join event** – RSVP  
• **Leave event** – cancel RSVP  
• **Logout** – return to main menu  
• **Exit** – quit the program

---

## Troubleshooting

### Database connection

```bash
# macOS (Homebrew)
brew services list | grep postgres

# Linux (systemd)
sudo service postgresql status

# Test credentials
psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "SELECT 1;"
```

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

## Development tips

• Modify the SQL scripts and rerun `setup.sql` to iterate on the schema.  
• Use `psql` or GUI clients (pgAdmin, TablePlus, DBeaver) to inspect data.  
• Add additional npm scripts to automate tasks (e.g. `npm run lint`).

---

## Production notes

1. Use a dedicated, least-privilege PostgreSQL role.  
2. Store sensitive env vars securely (e.g. Docker secrets, CI vault).  
3. Consider Docker for easy reproducibility and deployment.

---

`node_modules/` is deliberately **not** in version control; reinstall dependencies with `npm install` at any time.
