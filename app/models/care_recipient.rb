class CareRecipient < ApplicationRecord

    has_one_attached :photo
    attr_accessor :remove_photo

    has_many :family_memberships, dependent: :destroy
    has_many :family_members, through: :family_memberships, source: :user
    has_many :visit_reports, dependent: :destroy
    has_many :vitals, dependent: :destroy
    has_many :adl_records, dependent: :destroy
    has_many :medication_records, dependent: :destroy
    has_many :emergency_contacts, -> { order(:priority) }, dependent: :destroy
    has_many :care_recipient_visit_types, dependent: :destroy
    has_many :visit_types, through: :care_recipient_visit_types


    def age
        return nil if birthday.blank?

        today = Date.today
        age = today.year - birthday.year
        age -= 1 if today < birthday + age.years
        age
    end


end
