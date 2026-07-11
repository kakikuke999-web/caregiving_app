class VisitType < ApplicationRecord
  has_many :care_recipient_visit_types, dependent: :destroy
  has_many :care_recipients, through: :care_recipient_visit_types
  has_many :visit_reports, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
end
