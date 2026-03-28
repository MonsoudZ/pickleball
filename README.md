# Pickleball Performance Lab

Rails 8 personal training web app for pickleball coaching.

## Stack

- Ruby 4.0.1
- Rails 8.1
- PostgreSQL
- Tailwind CSS
- Hotwire Turbo + Turbo Frames

## Features

- Homepage with upcoming sessions, programs, and coach bios
- Dedicated About page for coach profile
- Dedicated FAQ page
- Pricing page with tabbed training menu
- Contact form for session requests
- Turbo Frame-powered monthly training calendar
- Compact session popover loaded without full page refresh
- Fake demo dataset via `db:seed_demo` with one coach, programs, and sessions backfilled 12 months plus 3 months ahead

## Setup

```bash
bundle install
bin/rails db:create
bin/rails db:prepare
bin/rails db:seed_demo
bin/dev
```

Then open [http://localhost:3000](http://localhost:3000).

## PostgreSQL Notes

- Development database: `pickleball_development`
- Test database: `pickleball_test`
- Optional override: set `DATABASE_URL` to point at your PostgreSQL instance

## Demo Seeding

- `bin/rails db:seed` is intentionally a no-op.
- Use `bin/rails db:seed_demo` for fake coaching activity data.
- Optional custom range:
  - `bin/rails 'db:seed_demo[12,3]'`
  - `BACKFILL_MONTHS=12 FORWARD_MONTHS=3 bin/rails db:seed_demo`

## ActiveAdmin

- Admin panel URL: `/admin`
- ActiveAdmin resources are set up for:
  - Coaches
  - Training Programs
  - Training Sessions
  - Admin Users

Create or update an admin login:

```bash
bin/rails db:seed_admin
# or custom credentials
ADMIN_EMAIL=you@example.com ADMIN_PASSWORD=strong-password bin/rails db:seed_admin
```

## Railway Production Checklist

Run these after deploy (or on each fresh production database):

```bash
RAILS_ENV=production bin/rails db:migrate
RAILS_ENV=production bin/rails db:seed_demo
RAILS_ENV=production ADMIN_EMAIL=you@example.com ADMIN_PASSWORD=strong-password bin/rails db:seed_admin
```

Notes:
- `db:seed_demo` is fake portfolio data only (no real clients).
- `db:seed_admin` is idempotent for the same email: rerunning updates password/details instead of creating duplicates.

## Main Routes

- `/` home page
- `/about` coach/about section
- `/faq` frequently asked questions
- `/pricing` pricing menu tabs
- `/contact` contact request form
- `/calendar` monthly calendar (Turbo Frame navigation)
- `/training_sessions/:id` session detail (frame-friendly)
