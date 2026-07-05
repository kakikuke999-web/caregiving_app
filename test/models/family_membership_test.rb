require "test_helper"

class FamilyMembershipTest < ActiveSupport::TestCase
  test "valid with a family-role user and unique care_recipient pairing" do
    membership = FamilyMembership.new(user: users(:family_two), care_recipient: care_recipients(:two))
    assert membership.valid?
  end

  test "invalid when the user does not have the family role" do
    membership = FamilyMembership.new(user: users(:one), care_recipient: care_recipients(:two))
    assert_not membership.valid?
    assert_includes membership.errors[:user], "はfamilyロールのユーザーのみ選択できます"
  end

  test "invalid when the same user/care_recipient pair already exists" do
    membership = FamilyMembership.new(user: users(:family_one), care_recipient: care_recipients(:one))
    assert_not membership.valid?
    assert_includes membership.errors[:user_id], "はすでにこの要介護者と紐付いています"
  end
end
