class Vital < ApplicationRecord
  self.inheritance_column = nil

  TYPES = %w[blood_pressure pulse temperature weight blood_glucose].freeze

  UNITS = {
    "pulse" => "回/分",
    "temperature" => "℃",
    "weight" => "kg",
    "blood_glucose" => "mg/dL"
  }.freeze

  LABELS = {
    "blood_pressure" => "血圧",
    "pulse" => "脈拍",
    "temperature" => "体温",
    "weight" => "体重",
    "blood_glucose" => "血糖値"
  }.freeze

  belongs_to :care_recipient
  belongs_to :recorded_by, class_name: "User"

  validates :type, inclusion: { in: TYPES }
  validates :recorded_at, presence: true
  validates :value, presence: true, unless: -> { type == "blood_pressure" }
  validates :systolic, :diastolic, presence: true, if: -> { type == "blood_pressure" }

  def label
    LABELS[type]
  end

  def unit
    UNITS[type]
  end
end
