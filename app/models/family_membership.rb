class FamilyMembership < ApplicationRecord
  belongs_to :user
  belongs_to :care_recipient

  validates :user_id, uniqueness: { scope: :care_recipient_id, message: "はすでにこの要介護者と紐付いています" }
  validate :user_must_have_family_role

  private

  def user_must_have_family_role
    errors.add(:user, "はfamilyロールのユーザーのみ選択できます") if user && !user.family?
  end
end
