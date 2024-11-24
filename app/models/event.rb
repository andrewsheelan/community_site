class Event < ApplicationRecord
  belongs_to :user
  has_many :event_changes, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, presence: true
  validates :start_time, presence: true
  validates :user, presence: true
  validates :end_time, presence: true
  validates :location, presence: true
  validate :end_time_after_start_time

  scope :upcoming, -> { where("start_time >= ?", Time.current).order(start_time: :asc) }
  scope :past, -> { where("end_time < ?", Time.current).order(start_time: :desc) }
  scope :this_month, -> { where(start_time: Time.current.beginning_of_month..Time.current.end_of_month) }

  after_create :track_creation
  after_update :track_update

  def duration
    ((end_time - start_time) / 1.hour).round(1)
  end

  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time < start_time
      errors.add(:end_time, "must be after the start time")
    end
  end

  def track_creation
    event_changes.create!(
      user: user,
      action: "created",
      changes_made: attributes.except("id", "created_at", "updated_at").to_json
    )
  end

  def track_update
    if saved_changes.present?
      event_changes.create!(
        user: user,
        action: "updated",
        changes_made: saved_changes.except("updated_at").to_json
      )
    end
  end
end
