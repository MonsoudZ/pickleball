namespace :db do
  desc "Create or update an ActiveAdmin login user"
  task :seed_admin, [ :email, :password ] => :environment do |_task, args|
    email = args[:email] || ENV.fetch("ADMIN_EMAIL", "admin@example.com")
    password = args[:password] || ENV.fetch("ADMIN_PASSWORD", "changeme123")

    admin = AdminUser.find_or_initialize_by(email: email)
    admin.password = password
    admin.password_confirmation = password
    admin.save!

    puts "Admin user ready: #{email}"
  end
end
