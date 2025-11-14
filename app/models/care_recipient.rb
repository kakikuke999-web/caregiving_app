class CareRecipient < ApplicationRecord
  has_many :visit_reports, dependent: :destroy
  has_many :care_recipient_visit_types
  has_many :visit_types, through: :care_recipient_visit_types

end
