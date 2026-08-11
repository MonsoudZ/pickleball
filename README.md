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
- Persisted contact inquiries with admin workflow statuses
- Turbo Frame-powered monthly training calendar
- Compact session popover loaded without full page refresh
- Fake demo dataset via `db:seed_demo` with one coach, programs, and sessions backfilled 12 months plus 3 months ahead

## Setup

```bash
bundle install
bin/rails db:create
bin/rails db:prepare
bin/rails db:seed
bin/dev
```

Then open [http://localhost:3000](http://localhost:3000).

## PostgreSQL Notes

- Development database: `pickleball_development`
- Test database: `pickleball_test`
- Optional override: set `DATABASE_URL` to point at your PostgreSQL instance

## Data Seeding

- `bin/rails db:seed` creates only a production-safe coach profile with no invented credentials, programs, sessions, or bookings.
- Use `bin/rails db:seed_demo` only for local development. It creates fictional coaching activity and must not be used as evidence of real clients or availability.
- Optional custom range:
  - `bin/rails 'db:seed_demo[12,3]'`
  - `BACKFILL_MONTHS=12 FORWARD_MONTHS=3 bin/rails db:seed_demo`

## ActiveAdmin

- Admin panel URL: `/admin`
- ActiveAdmin resources are set up for:
  - Coaches
  - Training Programs
  - Training Sessions
  - Inquiries
  - Admin Users

Create or update an admin login:

```bash
bin/rails db:seed_admin
# or custom credentials
ADMIN_EMAIL=you@example.com ADMIN_PASSWORD=strong-password bin/rails db:seed_admin
```

### Public session controls

- New and existing sessions default to unpublished.
- A session appears publicly only when `Published` is checked and its status is `scheduled`.
- Changing a session to `canceled` immediately removes it from the homepage, calendar, detail route, and sitemap.

## Production Identity and SEO

Configure these environment variables in production:

```bash
SITE_URL=https://your-domain.example
BUSINESS_EMAIL=training@your-domain.example
BUSINESS_PHONE=+1-303-555-0100
```

- `SITE_URL` drives canonical URLs, Open Graph URLs, structured data, robots.txt, and the XML sitemap.
- `BUSINESS_EMAIL` and `BUSINESS_PHONE` are optional. They appear publicly only when configured, so the app never invents contact details.
- Use a real dedicated business email and phone number before setting those values.

## Railway Production Checklist

Run these after deploy (or on each fresh production database):

```bash
RAILS_ENV=production bin/rails db:migrate
RAILS_ENV=production bin/rails db:seed
RAILS_ENV=production ADMIN_EMAIL=you@example.com ADMIN_PASSWORD=strong-password bin/rails db:seed_admin
```

Notes:
- Do not run `db:seed_demo` in production; its sessions and booking counts are fictional.
- Add verified credentials, current programs, and actual availability through `/admin`.
- `db:seed_admin` is idempotent for the same email: rerunning updates password/details instead of creating duplicates.

## Main Routes

- `/` home page
- `/about` coach/about section
- `/faq` frequently asked questions
- `/pricing` pricing menu tabs
- `/contact` contact request form
- `/calendar` monthly calendar (Turbo Frame navigation)
- `/training_sessions/:id` session detail (frame-friendly)
