require "test_helper"

class DashboardPolicyTest < ActiveSupport::TestCase
  test "admin can view the dashboard" do
    policy = DashboardPolicy.new(users(:one), :dashboard)
    assert policy.index?
  end

  test "care_manager can view the dashboard" do
    policy = DashboardPolicy.new(users(:care_manager_one), :dashboard)
    assert policy.index?
  end

  test "staff cannot view the dashboard" do
    policy = DashboardPolicy.new(users(:staff_one), :dashboard)
    assert_not policy.index?
  end

  test "family cannot view the dashboard" do
    policy = DashboardPolicy.new(users(:family_one), :dashboard)
    assert_not policy.index?
  end
end
