class PersonalSchedule < ApplicationRecord
  belongs_to :care_recipient
  belongs_to :created_by, class_name: "User"

  validates :title, presence: true
  validates :started_at, presence: true
  validate :ended_at_after_started_at

  private

  def ended_at_after_started_at
    return if ended_at.blank? || started_at.blank?

    errors.add(:ended_at, "は開始時刻より後にしてください") if ended_at < started_at
  end
end
