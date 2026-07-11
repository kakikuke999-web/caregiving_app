class VisitReport < ApplicationRecord
  belongs_to :care_recipient
  belongs_to :visit_type
  belongs_to :user

  enum status: { planned: 0, completed: 1, missed: 2 }

  validate :ended_at_after_visited_at

  private

  def ended_at_after_visited_at
    return if ended_at.blank? || visited_at.blank?

    errors.add(:ended_at, "は開始時刻より後にしてください") if ended_at < visited_at
  end
end
