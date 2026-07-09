class MedicationRecord < ApplicationRecord
  belongs_to :care_recipient
  belongs_to :recorded_by, class_name: "User"

  validates :medication_name, presence: true
  validates :recorded_at, presence: true
end
