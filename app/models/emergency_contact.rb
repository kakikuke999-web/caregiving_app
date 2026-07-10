class EmergencyContact < ApplicationRecord
  belongs_to :care_recipient

  validates :name, presence: true
  validates :phone_number, presence: true
end
