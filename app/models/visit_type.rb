class VisitType < ApplicationRecord
  has_many :care_recipient_visit_types
  has_many :care_recipients, through: :care_recipient_visit_types
  has_many :visit_reports

end
