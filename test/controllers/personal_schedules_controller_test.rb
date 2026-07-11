require "test_helper"

class PersonalSchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @care_recipient = care_recipients(:one)
    @personal_schedule = personal_schedules(:one)
  end

  test "family can create a personal schedule for their own recipient" do
    sign_in users(:family_one)
    assert_difference("PersonalSchedule.count") do
      post care_recipient_personal_schedules_url(@care_recipient), params: {
        personal_schedule: {
          title: "通院",
          "started_at(1i)" => "2026", "started_at(2i)" => "8", "started_at(3i)" => "1",
          "started_at(4i)" => "10", "started_at(5i)" => "0"
        }
      }
    end

    created = PersonalSchedule.last
    assert_equal users(:family_one), created.created_by
    assert_redirected_to calendar_care_recipient_path(@care_recipient)
  end

  test "family cannot create a personal schedule for a recipient they are not linked to" do
    sign_in users(:family_one)
    other_recipient = care_recipients(:two)

    assert_no_difference("PersonalSchedule.count") do
      post care_recipient_personal_schedules_url(other_recipient), params: {
        personal_schedule: {
          title: "通院",
          "started_at(1i)" => "2026", "started_at(2i)" => "8", "started_at(3i)" => "1",
          "started_at(4i)" => "10", "started_at(5i)" => "0"
        }
      }
    end
  end

  test "family can update and destroy their own recipient's personal schedule" do
    sign_in users(:family_one)

    patch care_recipient_personal_schedule_url(@care_recipient, @personal_schedule), params: {
      personal_schedule: { title: "更新後のタイトル" }
    }
    assert_redirected_to calendar_care_recipient_path(@care_recipient)
    assert_equal "更新後のタイトル", @personal_schedule.reload.title

    assert_difference("PersonalSchedule.count", -1) do
      delete care_recipient_personal_schedule_url(@care_recipient, @personal_schedule)
    end
  end

  test "unrelated family member cannot update another recipient's personal schedule" do
    sign_in users(:family_two)
    patch care_recipient_personal_schedule_url(@care_recipient, @personal_schedule), params: {
      personal_schedule: { title: "不正な更新" }
    }
    assert_not_equal "不正な更新", @personal_schedule.reload.title
  end

  test "calendar_events returns json scoped to the care recipient" do
    sign_in users(:staff_one)
    get personal_schedule_events_care_recipient_url(@care_recipient)
    assert_response :success
  end
end
