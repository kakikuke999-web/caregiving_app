require "test_helper"

class RecurringScheduleTest < ActiveSupport::TestCase
  def build_schedule(attrs = {})
    RecurringSchedule.new(
      {
        care_recipient: care_recipients(:one),
        visit_type: visit_types(:one),
        created_by: users(:one),
        day_of_week: 1,
        start_time: "10:00"
      }.merge(attrs)
    )
  end

  test "valid with an internal user assigned" do
    schedule = build_schedule(user: users(:staff_one))
    assert schedule.valid?
  end

  test "valid with only a provider_name (no internal user)" do
    schedule = build_schedule(provider_name: "ふれんず訪問看護ステーション")
    assert schedule.valid?
  end

  test "invalid without either a user or a provider_name" do
    schedule = build_schedule
    assert_not schedule.valid?
  end

  test "invalid with an end_time before start_time" do
    schedule = build_schedule(user: users(:staff_one), start_time: "15:00", end_time: "10:00")
    assert_not schedule.valid?
  end

  test "day_name returns the Japanese weekday label" do
    schedule = build_schedule(user: users(:staff_one), day_of_week: 3)
    assert_equal "水", schedule.day_name
  end
end
