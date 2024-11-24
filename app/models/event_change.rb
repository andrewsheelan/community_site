class EventChange < ApplicationRecord
  belongs_to :event
  belongs_to :user

  validates :action, presence: true, inclusion: { in: %w[created updated] }
  validates :changes_made, presence: true
end
