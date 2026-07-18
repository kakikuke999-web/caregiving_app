require "test_helper"

class CareRecipientPolicyTest < ActiveSupport::TestCase
  test "admin and care_manager can create, update, and destroy" do
    [:one, :care_manager_one].each do |fixture|
      policy = CareRecipientPolicy.new(users(fixture), care_recipients(:one))
      assert policy.create?
      assert policy.update?
      assert policy.destroy?
    end
  end

  test "staff can view but not create, update, or destroy" do
    policy = CareRecipientPolicy.new(users(:staff_one), care_recipients(:one))
    assert policy.show?
    assert_not policy.create?
    assert_not policy.update?
    assert_not policy.destroy?
  end

  test "family can view their own recipient but not others" do
    assert CareRecipientPolicy.new(users(:family_one), care_recipients(:one)).show?
    assert_not CareRecipientPolicy.new(users(:family_one), care_recipients(:two)).show?
  end

  test "family cannot create, update, or destroy" do
    policy = CareRecipientPolicy.new(users(:family_one), care_recipients(:one))
    assert_not policy.create?
    assert_not policy.update?
    assert_not policy.destroy?
  end

  test "scope resolves to all recipients for staff, only linked ones for family" do
    assert_includes CareRecipientPolicy::Scope.new(users(:staff_one), CareRecipient).resolve, care_recipients(:two)

    family_scope = CareRecipientPolicy::Scope.new(users(:family_one), CareRecipient).resolve
    assert_includes family_scope, care_recipients(:one)
    assert_not_includes family_scope, care_recipients(:two)
  end
end
