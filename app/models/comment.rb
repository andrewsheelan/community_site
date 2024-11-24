class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :content, presence: true

  default_scope { order(created_at: :desc) }

  # Format the comment's created_at timestamp in a friendly way
  def friendly_created_at
    if created_at.today?
      created_at.strftime("Today at %I:%M %p")
    elsif created_at.to_date == Date.yesterday
      created_at.strftime("Yesterday at %I:%M %p")
    else
      created_at.strftime("%B %d at %I:%M %p")
    end
  end
end
