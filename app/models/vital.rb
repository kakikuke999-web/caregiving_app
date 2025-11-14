class Vital < ApplicationRecord
  belongs_to :care_recipient
  belongs_to :recorded_by
end
