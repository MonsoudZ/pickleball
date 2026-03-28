# Intentionally minimal default seed.
#
# Use demo seed task for fake public-facing activity data:
#   bin/rails db:seed_demo
#
# Optional ranges:
#   bin/rails 'db:seed_demo[12,3]'
#   BACKFILL_MONTHS=12 FORWARD_MONTHS=3 bin/rails db:seed_demo
# Admin user:
#   bin/rails db:seed_admin
#   ADMIN_EMAIL=you@example.com ADMIN_PASSWORD=yourpass bin/rails db:seed_admin

puts "Default db:seed completed (no-op). Run `bin/rails db:seed_demo` for demo dataset."
