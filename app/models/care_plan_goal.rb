class CarePlanGoal < ApplicationRecord
  belongs_to :care_plan

  has_many :care_plan_services, -> { order(:position) }, dependent: :destroy
  accepts_nested_attributes_for :care_plan_services, allow_destroy: true,
    reject_if: ->(attrs) { attrs["content"].blank? }
end
