# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create AI assistant user
ai_user = User.find_or_initialize_by(email: 'ai.assistant@example.com')
if ai_user.new_record?
  ai_user.password = SecureRandom.hex(16)
  ai_user.save!
  puts "Created AI assistant user"
else
  puts "AI assistant user already exists"
end

# Create 5 sample users
puts "Creating sample users..."

sample_users = [
  { email: 'john.doe@example.com', password: 'password123' },
  { email: 'jane.smith@example.com', password: 'password123' },
  { email: 'alex.wilson@example.com', password: 'password123' },
  { email: 'sarah.brown@example.com', password: 'password123' },
  { email: 'mike.davis@example.com', password: 'password123' }
]

sample_users.each do |user_data|
  user = User.find_or_initialize_by(email: user_data[:email])
  if user.new_record?
    user.password = user_data[:password]
    user.password_confirmation = user_data[:password]
    user.save!
    puts "Created user: #{user.email}"
  else
    puts "User already exists: #{user.email}"
  end
end

puts "Seed completed successfully!"
