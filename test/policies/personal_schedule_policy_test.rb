require "test_helper"

class PersonalSchedulePolicyTest < ActiveSupport::TestCase
  test "staff can create, update, and destroy any personal schedule" do
    policy = PersonalSchedulePolicy.new(users(:staff_one), personal_schedules(:one))
    assert policy.show?
    assert policy.create?
    assert policy.update?
    assert policy.destroy?
  end

  test "family can create, update, and destroy their own recipient's personal schedule" do
    policy = PersonalSchedulePolicy.new(users(:family_one), personal_schedules(:one))
    assert policy.show?
    assert policy.create?
    assert policy.update?
    assert policy.destroy?
  end

  test "family cannot view or manage another recipient's personal schedule" do
    policy = PersonalSchedulePolicy.new(users(:family_one), personal_schedules(:two))
    assert_not policy.show?
    assert_not policy.create?
  end
end
