require "test_helper"

class UserPolicyTest < ActiveSupport::TestCase
  test "admin and care_manager can view and update users, staff and family cannot" do
    assert UserPolicy.new(users(:one), users(:staff_one)).index?
    assert UserPolicy.new(users(:care_manager_one), users(:staff_one)).index?
    assert_not UserPolicy.new(users(:staff_one), users(:staff_one)).index?
    assert_not UserPolicy.new(users(:family_one), users(:staff_one)).index?

    assert UserPolicy.new(users(:one), users(:staff_one)).update?
    assert UserPolicy.new(users(:care_manager_one), users(:staff_one)).update?
    assert_not UserPolicy.new(users(:staff_one), users(:staff_one)).update?
  end

  test "scope resolves to all users for admin and care_manager, none for others" do
    assert_equal User.all.to_a, UserPolicy::Scope.new(users(:one), User).resolve.to_a
    assert_equal User.all.to_a, UserPolicy::Scope.new(users(:care_manager_one), User).resolve.to_a
    assert_empty UserPolicy::Scope.new(users(:staff_one), User).resolve
    assert_empty UserPolicy::Scope.new(users(:family_one), User).resolve
  end

  test "admin may assign any role, including admin" do
    roles = UserPolicy.new(users(:one), users(:staff_one)).assignable_roles
    assert_includes roles, "admin"
  end

  test "care_manager may not promote a non-admin user to admin" do
    roles = UserPolicy.new(users(:care_manager_one), users(:staff_one)).assignable_roles
    assert_not_includes roles, "admin"
  end

  test "care_manager keeps an existing admin's role assignable so editing them doesn't force a demotion" do
    roles = UserPolicy.new(users(:care_manager_one), users(:one)).assignable_roles
    assert_includes roles, "admin"
  end
end
