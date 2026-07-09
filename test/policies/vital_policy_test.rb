require "test_helper"

class VitalPolicyTest < ActiveSupport::TestCase
  test "staff can create and update but not destroy" do
    policy = VitalPolicy.new(users(:staff_one), vitals(:one))
    assert policy.create?
    assert policy.update?
    assert_not policy.destroy?
  end

  test "family can view own recipient's vitals but not create" do
    policy = VitalPolicy.new(users(:family_one), vitals(:one))
    assert policy.show?
    assert_not policy.create?
  end

  test "family cannot view other recipient's vitals" do
    policy = VitalPolicy.new(users(:family_one), vitals(:two))
    assert_not policy.show?
  end

  test "scope resolves to accessible recipients only for family" do
    scope = VitalPolicy::Scope.new(users(:family_one), Vital).resolve
    assert_includes scope, vitals(:one)
    assert_not_includes scope, vitals(:two)
  end

  test "scope resolves to all vitals for staff" do
    scope = VitalPolicy::Scope.new(users(:staff_one), Vital).resolve
    assert_includes scope, vitals(:one)
    assert_includes scope, vitals(:two)
  end
end
