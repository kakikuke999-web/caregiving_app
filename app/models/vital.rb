class Vital < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :care_recipient
  belongs_to :recorded_by, class_name: "User"
end
