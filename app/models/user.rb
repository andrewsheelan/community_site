class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_and_belongs_to_many :roles
  has_many :chat_rooms, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :event_changes, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :chat_room_members, dependent: :destroy
  has_many :joined_chat_rooms, through: :chat_room_members, source: :chat_room

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  after_create :assign_default_role
  before_validation :set_default_name, on: :create

  def start_conversation_with(other_user)
    return nil if self == other_user
    
    ChatRoom.create_private_room([self, other_user])
  end

  def display_name
    name.presence || email.split('@').first
  end

  # Role methods
  def add_role(role_name)
    role = Role.find_by(name: role_name)
    roles << role if role && !roles.include?(role)
  end

  def remove_role(role_name)
    role = Role.find_by(name: role_name)
    roles.delete(role) if role
  end

  def has_role?(role_name)
    roles.exists?(name: role_name)
  end

  def admin?
    has_role?(Role::ADMIN)
  end

  def moderator?
    has_role?(Role::MODERATOR)
  end

  def member?
    has_role?(Role::MEMBER)
  end

  def highest_role
    return Role::ADMIN if admin?
    return Role::MODERATOR if moderator?
    Role::MEMBER
  end

  private

  def set_default_name
    self.name ||= email.split('@').first if email
  end

  def assign_default_role
    add_role(Role::MEMBER) unless roles.any?
  end
end
