require "test_helper"

class VisitTypePolicyTest < ActiveSupport::TestCase
  test "admin can manage visit types" do
    policy = VisitTypePolicy.new(users(:one), VisitType)
    assert policy.index?
    assert policy.create?
    assert policy.destroy?
  end

  test "care_manager can manage visit types" do
    policy = VisitTypePolicy.new(users(:care_manager_one), VisitType)
    assert policy.index?
    assert policy.create?
    assert policy.destroy?
  end

  test "staff cannot manage visit types" do
    policy = VisitTypePolicy.new(users(:staff_one), VisitType)
    assert_not policy.index?
    assert_not policy.create?
    assert_not policy.destroy?
  end

  test "family cannot manage visit types" do
    policy = VisitTypePolicy.new(users(:family_one), VisitType)
    assert_not policy.index?
  end
end
