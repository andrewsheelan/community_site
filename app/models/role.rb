class Role < ApplicationRecord
  has_and_belongs_to_many :users

  validates :name, presence: true, uniqueness: true

  # Define common role names as constants
  ADMIN = 'admin'
  MODERATOR = 'moderator'
  MEMBER = 'member'

  # Scope to find roles by name
  scope :admin, -> { find_by(name: ADMIN) }
  scope :moderator, -> { find_by(name: MODERATOR) }
  scope :member, -> { find_by(name: MEMBER) }
end
