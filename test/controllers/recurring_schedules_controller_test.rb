require "test_helper"

class RecurringSchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @care_recipient = care_recipients(:one)
  end

  test "staff can create a recurring schedule with an internal user" do
    sign_in users(:staff_one)

    assert_difference("RecurringSchedule.count") do
      post care_recipient_recurring_schedules_url(@care_recipient), params: {
        recurring_schedule: {
          visit_type_id: visit_types(:one).id,
          user_id: users(:staff_one).id,
          day_of_week: 1,
          start_time: "10:00"
        }
      }
    end

    schedule = RecurringSchedule.last
    assert_equal users(:staff_one), schedule.created_by
  end

  test "staff can create a recurring schedule for an external provider with no user" do
    sign_in users(:staff_one)

    assert_difference("RecurringSchedule.count") do
      post care_recipient_recurring_schedules_url(@care_recipient), params: {
        recurring_schedule: {
          visit_type_id: visit_types(:one).id,
          day_of_week: 3,
          start_time: "09:00",
          provider_name: "ふれんず訪問看護ステーション"
        }
      }
    end

    assert_nil RecurringSchedule.last.user
  end

  test "family cannot create a recurring schedule" do
    sign_in users(:family_one)

    assert_no_difference("RecurringSchedule.count") do
      post care_recipient_recurring_schedules_url(@care_recipient), params: {
        recurring_schedule: { visit_type_id: visit_types(:one).id, day_of_week: 1, start_time: "10:00", provider_name: "x" }
      }
    end
  end

  test "generate creates visit reports from active schedules" do
    sign_in users(:staff_one)
    RecurringSchedule.create!(
      care_recipient: @care_recipient, visit_type: visit_types(:one), user: users(:staff_one),
      created_by: users(:one), day_of_week: Date.current.wday, start_time: "10:00"
    )

    assert_difference("VisitReport.count", 9) do # today + one match every 7 days over the default 8-week window
      post generate_care_recipient_recurring_schedules_url(@care_recipient)
    end
    assert_redirected_to care_recipient_recurring_schedules_url(@care_recipient)
  end

  test "admin can destroy a recurring schedule" do
    schedule = recurring_schedules(:one)
    sign_in users(:one)

    assert_difference("RecurringSchedule.count", -1) do
      delete care_recipient_recurring_schedule_url(schedule.care_recipient, schedule)
    end
  end

  test "staff cannot destroy a recurring schedule" do
    schedule = recurring_schedules(:one)
    sign_in users(:staff_one)

    assert_no_difference("RecurringSchedule.count") do
      delete care_recipient_recurring_schedule_url(schedule.care_recipient, schedule)
    end
  end
end
