class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_rich_text :content

  validates :title, presence: true
  validates :content, presence: true

  scope :published, -> { where(published: true) }
  scope :recent, -> { order(created_at: :desc) }
  scope :with_user, -> { includes(:user) }

  def author_name
    user.email.split("@").first
  end

  def reading_time
    words_per_minute = 200
    word_count = content.to_plain_text.split.size
    minutes = (word_count.to_f / words_per_minute).ceil
    "#{minutes} min read"
  end

  def publish!
    update(published: true)
  end

  def unpublish!
    update(published: false)
  end
end
