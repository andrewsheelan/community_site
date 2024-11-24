# Clear existing data
puts "Clearing existing data..."
[ User, Post, Event, ChatRoom, Message, Comment ].each(&:delete_all)

# Create admin user
puts "Creating admin user..."
admin = User.create!(
  email: 'admin@example.com',
  password: 'password123',
  name: 'Admin User',
  admin: true
)

# Create regular users
puts "Creating regular users..."
users = [
  { name: 'Alice Johnson', email: 'alice@example.com' },
  { name: 'Bob Smith', email: 'bob@example.com' },
  { name: 'Carol White', email: 'carol@example.com' },
  { name: 'David Brown', email: 'david@example.com' }
].map do |user_data|
  User.create!(
    email: user_data[:email],
    password: 'password123',
    name: user_data[:name]
  )
end

# Create posts
puts "Creating posts..."
posts = [
  {
    title: 'Welcome to Our Vintage Community!',
    content: 'This is a space where we can share our love for all things vintage. From fashion to furniture, let\'s celebrate the timeless beauty of the past.',
    user: admin,
    published: true
  },
  {
    title: 'Tips for Collecting Vintage Records',
    content: 'Vinyl records are making a comeback! Here are some tips for starting your collection: 1. Research the era you\'re interested in, 2. Check the condition carefully, 3. Invest in proper storage...',
    user: users[0],
    published: true
  },
  {
    title: 'Restoring Antique Furniture',
    content: 'Restoring antique furniture can be a rewarding hobby. Here\'s my experience with restoring a 19th-century writing desk...',
    user: users[1],
    published: true
  }
].map { |post_data| Post.create!(post_data) }

# Create events
puts "Creating events..."
events = [
  {
    title: 'Vintage Market Fair',
    description: 'Join us for a day of vintage shopping, music, and fun! Local vendors will be showcasing their best vintage finds.',
    start_time: 2.days.from_now,
    end_time: 2.days.from_now + 8.hours,
    location: 'Central Park',
    user: admin
  },
  {
    title: 'Retro Gaming Night',
    description: 'Bring your favorite classic games and consoles for a night of retro gaming fun!',
    start_time: 5.days.from_now,
    end_time: 5.days.from_now + 4.hours,
    location: 'Community Center',
    user: users[2]
  },
  {
    title: 'Vintage Fashion Workshop',
    description: 'Learn about vintage fashion eras and how to style vintage pieces in a modern way.',
    start_time: 7.days.from_now,
    end_time: 7.days.from_now + 3.hours,
    location: 'Fashion Studio',
    user: users[1]
  }
].map { |event_data| Event.create!(event_data) }

# Create chat rooms
puts "Creating chat rooms..."
chat_rooms = [
  {
    name: 'Vintage Collectors',
    description: 'A place to discuss vintage collectibles and share finds',
    user: admin,
    private: false
  },
  {
    name: 'Retro Gaming',
    description: 'Discuss classic video games and consoles',
    user: users[2],
    private: false
  }
].map { |room_data| ChatRoom.create!(room_data) }

# Create messages in chat rooms
puts "Creating chat messages..."
chat_rooms.each do |room|
  Message.create!(
    content: "Welcome to the #{room.name} chat room!",
    user: room.user,
    chat_room: room
  )
end

# Create comments for posts
puts "Creating comments for posts..."
posts.each do |post|
  users.sample(3).each do |user|
    Comment.create!(
      content: [
        "This is such a great post! Thanks for sharing.",
        "I really enjoyed reading this. Looking forward to more content like this!",
        "Very informative! I learned a lot from this.",
        "Great insights! I'll definitely be trying these tips.",
        "Thanks for putting this together. Really helpful!"
      ].sample,
      user: user,
      commentable: post
    )
  end
end

# Create comments for events
puts "Creating comments for events..."
events.each do |event|
  users.sample(2).each do |user|
    Comment.create!(
      content: [
        "Can't wait for this event!",
        "This sounds amazing! I'll definitely be there.",
        "Looking forward to meeting everyone!",
        "Great initiative! Count me in.",
        "This is exactly what our community needs!"
      ].sample,
      user: user,
      commentable: event
    )
  end
end

puts "Seed data created successfully!"
