class CareRecipient < ApplicationRecord

    has_one_attached :photo
    attr_accessor :remove_photo


    def age
        return nil if birthday.blank?

        today = Date.today
        age = today.year - birthday.year
        age -= 1 if today < birthday + age.years
        age
    end


end
