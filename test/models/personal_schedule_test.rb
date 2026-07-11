require "test_helper"

class PersonalScheduleTest < ActiveSupport::TestCase
  test "valid with title, started_at, care_recipient, and created_by" do
    schedule = PersonalSchedule.new(care_recipient: care_recipients(:one), created_by: users(:family_one),
                                     title: "通院", started_at: Time.current)
    assert schedule.valid?
  end

  test "invalid without a title" do
    schedule = PersonalSchedule.new(care_recipient: care_recipients(:one), created_by: users(:family_one),
                                     started_at: Time.current)
    assert_not schedule.valid?
  end

  test "invalid when ended_at is before started_at" do
    schedule = PersonalSchedule.new(care_recipient: care_recipients(:one), created_by: users(:family_one),
                                     title: "通院", started_at: Time.current, ended_at: 1.hour.ago)
    assert_not schedule.valid?
  end
end
