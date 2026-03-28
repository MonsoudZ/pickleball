namespace :db do
  desc "Seed a fake demo dataset (default: 12 months backfill, 3 months forward)"
  task :seed_demo, [ :backfill_months, :forward_months ] => :environment do |_task, args|
    backfill_months = (args[:backfill_months] || ENV.fetch("BACKFILL_MONTHS", 12)).to_i
    forward_months = (args[:forward_months] || ENV.fetch("FORWARD_MONTHS", 3)).to_i

    DemoSeed.run(backfill_months: backfill_months, forward_months: forward_months)
  end
end
