require "test_helper"

class SupportLogPolicyTest < ActiveSupport::TestCase
  test "admin, care_manager, and staff can view and create" do
    [:one, :care_manager_one, :staff_one].each do |fixture|
      policy = SupportLogPolicy.new(users(fixture), support_logs(:one))
      assert policy.index?
      assert policy.show?
      assert policy.create?
    end
  end

  test "only admin and care_manager can destroy" do
    assert SupportLogPolicy.new(users(:one), support_logs(:one)).destroy?
    assert SupportLogPolicy.new(users(:care_manager_one), support_logs(:one)).destroy?
    assert_not SupportLogPolicy.new(users(:staff_one), support_logs(:one)).destroy?
  end

  test "family has no access at all, even to their own recipient's support logs" do
    policy = SupportLogPolicy.new(users(:family_one), support_logs(:one))
    assert_not policy.index?
    assert_not policy.show?
    assert_not policy.create?
  end

  test "scope resolves to none for family regardless of recipient" do
    assert_empty SupportLogPolicy::Scope.new(users(:family_one), SupportLog).resolve
  end

  test "scope resolves to all support logs for staff" do
    scope = SupportLogPolicy::Scope.new(users(:staff_one), SupportLog).resolve
    assert_includes scope, support_logs(:one)
    assert_includes scope, support_logs(:two)
  end
end
