class AdlRecord < ApplicationRecord
  belongs_to :care_recipient
  belongs_to :recorded_by, class_name: "User"

  enum meal_intake: { full: 0, most: 1, half: 2, little: 3, none: 4 }, _prefix: :meal
  enum excretion_status: { normal: 0, loose: 1, constipated: 2 }, _prefix: :excretion
  enum sleep_quality: { good: 0, fair: 1, poor: 2 }, _prefix: :sleep

  validates :recorded_at, presence: true

  MEAL_INTAKE_LABELS = {
    "full" => "全量", "most" => "大部分", "half" => "半分", "little" => "少量", "none" => "なし"
  }.freeze

  EXCRETION_STATUS_LABELS = {
    "normal" => "普通", "loose" => "下痢気味", "constipated" => "便秘気味"
  }.freeze

  SLEEP_QUALITY_LABELS = {
    "good" => "良好", "fair" => "普通", "poor" => "不良"
  }.freeze
end
