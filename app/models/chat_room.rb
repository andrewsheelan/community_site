class ChatRoom < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy
  has_many :chat_room_members, dependent: :destroy
  has_many :users, through: :chat_room_members

  validates :name, presence: true

  scope :private_rooms, -> { where(private: true) }
  scope :public_rooms, -> { where(private: false) }

  def self.create_private_room(users)
    return nil if users.length != 2

    existing_room = private_room_between(users)
    return existing_room if existing_room

    transaction do
      room = create!(
        name: "Private Chat",
        private: true,
        user: users.first
      )
      users.each { |user| room.chat_room_members.create!(user: user) }
      room
    end
  end

  def self.private_room_exists?(users)
    private_room_between(users).present?
  end

  def self.private_room_between(users)
    return nil if users.length != 2

    private_rooms
      .joins(:chat_room_members)
      .where(chat_room_members: { user_id: users.map(&:id) })
      .group("chat_rooms.id")
      .having("COUNT(chat_room_members.id) = 2")
      .first
  end

  def member?(user)
    chat_room_members.exists?(user: user)
  end
end
