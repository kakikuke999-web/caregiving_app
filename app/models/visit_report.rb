class VisitReport < ApplicationRecord
  belongs_to :care_recipient
  belongs_to :visit_type
  belongs_to :user

  enum status: { planned: 0, completed: 1, missed: 2 }

end
