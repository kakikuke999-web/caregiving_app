class CarePlan < ApplicationRecord
  belongs_to :care_recipient
  belongs_to :created_by, class_name: "User"

  has_many :care_plan_goals, -> { order(:position) }, dependent: :destroy
  accepts_nested_attributes_for :care_plan_goals, allow_destroy: true,
    reject_if: ->(attrs) { attrs["issue"].blank? && attrs["long_term_goal"].blank? && attrs["short_term_goal"].blank? }

  default_scope { order(created_on: :desc, created_at: :desc) }

  validates :created_on, presence: true

  def latest?
    self == care_recipient.care_plans.first
  end
end
