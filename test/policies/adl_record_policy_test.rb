require "test_helper"

class AdlRecordPolicyTest < ActiveSupport::TestCase
  test "staff can create and update but not destroy" do
    policy = AdlRecordPolicy.new(users(:staff_one), adl_records(:one))
    assert policy.create?
    assert policy.update?
    assert_not policy.destroy?
  end

  test "family can view own recipient's records but not create" do
    policy = AdlRecordPolicy.new(users(:family_one), adl_records(:one))
    assert policy.show?
    assert_not policy.create?
  end

  test "family cannot view other recipient's records" do
    policy = AdlRecordPolicy.new(users(:family_one), adl_records(:two))
    assert_not policy.show?
  end
end
