require "test_helper"

class CarePlanPolicyTest < ActiveSupport::TestCase
  test "admin and care_manager can create, update, and destroy" do
    [:one, :care_manager_one].each do |fixture|
      policy = CarePlanPolicy.new(users(fixture), care_plans(:one))
      assert policy.create?
      assert policy.update?
      assert policy.destroy?
    end
  end

  test "staff can view but not create, update, or destroy" do
    policy = CarePlanPolicy.new(users(:staff_one), care_plans(:one))
    assert policy.show?
    assert_not policy.create?
    assert_not policy.update?
    assert_not policy.destroy?
  end

  test "family can view own recipient's care plan but not create" do
    policy = CarePlanPolicy.new(users(:family_one), care_plans(:one))
    assert policy.show?
    assert_not policy.create?
  end

  test "family cannot view other recipient's care plan" do
    assert_not CarePlanPolicy.new(users(:family_one), care_plans(:two)).show?
  end

  test "scope resolves to accessible recipients only for family" do
    scope = CarePlanPolicy::Scope.new(users(:family_one), CarePlan).resolve
    assert_includes scope, care_plans(:one)
    assert_not_includes scope, care_plans(:two)
  end
end
