require "test_helper"

class CalendarPolicyTest < ActiveSupport::TestCase
  test "admin can view the calendar" do
    policy = CalendarPolicy.new(users(:one), :calendar)
    assert policy.index?
  end

  test "care_manager can view the calendar" do
    policy = CalendarPolicy.new(users(:care_manager_one), :calendar)
    assert policy.index?
  end

  test "staff cannot view the calendar" do
    policy = CalendarPolicy.new(users(:staff_one), :calendar)
    assert_not policy.index?
  end

  test "family cannot view the calendar" do
    policy = CalendarPolicy.new(users(:family_one), :calendar)
    assert_not policy.index?
  end
end
