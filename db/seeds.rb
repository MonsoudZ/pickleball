coach = Coach.find_or_create_by!(name: "Monsoud Zanaty")

puts "Production-safe seed completed. Coach profile ready: #{coach.name}."
puts "Add only verified credentials, programs, and real availability through /admin."
