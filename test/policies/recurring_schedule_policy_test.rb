require "test_helper"

class RecurringSchedulePolicyTest < ActiveSupport::TestCase
  test "staff can create, update, and generate but not destroy" do
    policy = RecurringSchedulePolicy.new(users(:staff_one), recurring_schedules(:one))
    assert policy.create?
    assert policy.update?
    assert policy.generate?
    assert_not policy.destroy?
  end

  test "admin and care_manager can destroy" do
    assert RecurringSchedulePolicy.new(users(:one), recurring_schedules(:one)).destroy?
    assert RecurringSchedulePolicy.new(users(:care_manager_one), recurring_schedules(:one)).destroy?
  end

  test "family can view own recipient's schedule but not create or generate" do
    policy = RecurringSchedulePolicy.new(users(:family_one), recurring_schedules(:one))
    assert policy.show?
    assert_not policy.create?
    assert_not policy.generate?
  end

  test "family cannot view other recipient's schedule" do
    assert_not RecurringSchedulePolicy.new(users(:family_one), recurring_schedules(:two)).show?
  end

  test "scope resolves to accessible recipients only for family" do
    scope = RecurringSchedulePolicy::Scope.new(users(:family_one), RecurringSchedule).resolve
    assert_includes scope, recurring_schedules(:one)
    assert_not_includes scope, recurring_schedules(:two)
  end
end
