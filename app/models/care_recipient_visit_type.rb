class CareRecipientVisitType < ApplicationRecord
  has_many :visit_reports
  belongs_to :care_recipient
  belongs_to :visit_type
end
