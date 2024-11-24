class Message < ApplicationRecord
  belongs_to :user
  validates :content, presence: true
  
  scope :in_order, -> { order(created_at: :asc) }
end
