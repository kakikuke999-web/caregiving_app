class RecurringSchedule < ApplicationRecord
  belongs_to :care_recipient
  belongs_to :visit_type
  belongs_to :user, optional: true
  belongs_to :created_by, class_name: "User"
  has_many :visit_reports, dependent: :nullify

  DAY_NAMES = %w[日 月 火 水 木 金 土].freeze

  validates :day_of_week, inclusion: { in: 0..6 }
  validates :start_time, presence: true
  validate :end_time_after_start_time
  validate :user_or_provider_present

  scope :active, -> { where(active: true) }

  def day_name
    DAY_NAMES[day_of_week]
  end

  def assignee_label
    user&.name || provider_name.presence || "未定"
  end

  def time_range_label
    return start_time.strftime("%H:%M") if end_time.blank?

    "#{start_time.strftime('%H:%M')}〜#{end_time.strftime('%H:%M')}"
  end

  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    errors.add(:end_time, "は開始時刻より後にしてください") if end_time < start_time
  end

  def user_or_provider_present
    return if user.present? || provider_name.present?

    errors.add(:base, "担当スタッフまたは提供事業者のどちらかを入力してください")
  end
end
