class User < ApplicationRecord
  enum role: {
    care_manager: 1,
    staff: 2,
    family: 3,
    admin: 0
  }

  has_many :family_memberships, dependent: :destroy
  has_many :care_recipients, through: :family_memberships

  # validates :name, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
