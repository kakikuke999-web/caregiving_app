class User < ApplicationRecord
  enum role: {
    care_manager: 1,
    staff: 2,
    family: 3,
    admin: 0
  }

  validates :name, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
