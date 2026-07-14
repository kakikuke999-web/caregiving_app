class SupportLog < ApplicationRecord
  belongs_to :care_recipient
  belongs_to :user

  default_scope { order(occurred_at: :desc) }

  CATEGORIES = %w[phone visit_office coordination family other].freeze

  LABELS = {
    "phone" => "電話連絡",
    "visit_office" => "来所",
    "coordination" => "他機関との調整",
    "family" => "家族対応",
    "other" => "その他"
  }.freeze

  validates :category, inclusion: { in: CATEGORIES }
  validates :occurred_at, presence: true
  validates :body, presence: true

  def label
    LABELS[category]
  end
end
