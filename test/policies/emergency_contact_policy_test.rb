require "test_helper"

class EmergencyContactPolicyTest < ActiveSupport::TestCase
  test "admin can create, update, and destroy" do
    policy = EmergencyContactPolicy.new(users(:one), emergency_contacts(:one))
    assert policy.create?
    assert policy.update?
    assert policy.destroy?
  end

  test "staff can view but not create, update, or destroy" do
    policy = EmergencyContactPolicy.new(users(:staff_one), emergency_contacts(:one))
    assert policy.show?
    assert_not policy.create?
    assert_not policy.update?
    assert_not policy.destroy?
  end

  test "family can view own recipient's contacts but not create" do
    policy = EmergencyContactPolicy.new(users(:family_one), emergency_contacts(:one))
    assert policy.show?
    assert_not policy.create?
  end

  test "family cannot view other recipient's contacts" do
    policy = EmergencyContactPolicy.new(users(:family_one), emergency_contacts(:two))
    assert_not policy.show?
  end
end
