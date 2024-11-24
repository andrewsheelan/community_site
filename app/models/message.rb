class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  validates :content, presence: true

  scope :in_order, -> { order(created_at: :asc) }

  broadcasts_to ->(message) { [ message.chat_room, "messages" ] }, inserts_by: :prepend
end
