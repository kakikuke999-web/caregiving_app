class VisitReport < ApplicationRecord
  belongs_to :care_recipient
  belongs_to :visit_type
  belongs_to :user
  has_many :comments, dependent: :destroy

  enum status: { planned: 0, completed: 1, missed: 2 }

  validate :ended_at_after_visited_at

  # 開始・終了が同じ日なら日付を1回だけ表示し、日をまたぐ場合のみ両方に日付を出す
  def time_range_label
    return nil if visited_at.blank?
    return I18n.l(visited_at, format: :short) if ended_at.blank?

    if visited_at.to_date == ended_at.to_date
      "#{I18n.l(visited_at, format: :short)}〜#{I18n.l(ended_at, format: :time_only)}"
    else
      "#{I18n.l(visited_at, format: :short)}〜#{I18n.l(ended_at, format: :short)}"
    end
  end

  private

  def ended_at_after_visited_at
    return if ended_at.blank? || visited_at.blank?

    errors.add(:ended_at, "は開始時刻より後にしてください") if ended_at < visited_at
  end
end
