require "test_helper"

class VisitReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @visit_report = visit_reports(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get visit_reports_url
    assert_response :success
  end

  test "should get show" do
    get visit_report_url(@visit_report)
    assert_response :success
  end

  test "should get new" do
    get new_visit_report_url, params: { care_recipient_id: @visit_report.care_recipient_id }
    assert_response :success
  end

  test "new defaults the assigned staff to the current user" do
    get new_visit_report_url, params: { care_recipient_id: @visit_report.care_recipient_id }
    assert_select "select#visit_report_user_id option[selected]", value: users(:one).id.to_s
  end

  test "new defaults the visit type when the care recipient has exactly one linked type" do
    care_recipient = care_recipients(:one)
    care_recipient.visit_types = [visit_types(:one)]

    get new_visit_report_url, params: { care_recipient_id: care_recipient.id }
    assert_select "select#visit_report_visit_type_id option[selected]", value: visit_types(:one).id.to_s
  end

  test "new offers all visit types when the care recipient has none linked" do
    care_recipient = care_recipients(:one)
    care_recipient.visit_types = []

    get new_visit_report_url, params: { care_recipient_id: care_recipient.id }
    assert_select "select#visit_report_visit_type_id option", count: VisitType.count + 1 # +1 for the blank prompt
  end

  test "should get edit" do
    get edit_visit_report_url(@visit_report)
    assert_response :success
  end

  test "should create visit_report with the care_recipient carried through from the form" do
    assert_difference("VisitReport.count") do
      post visit_reports_url, params: {
        visit_report: {
          care_recipient_id: care_recipients(:one).id,
          visit_type_id: visit_types(:one).id,
          user_id: users(:staff_one).id,
          notes: "verification note",
          status: "planned",
          "visited_at(1i)" => "2026", "visited_at(2i)" => "8", "visited_at(3i)" => "1",
          "visited_at(4i)" => "10", "visited_at(5i)" => "0"
        }
      }
    end

    created = VisitReport.last
    assert_equal care_recipients(:one), created.care_recipient
    assert_equal users(:staff_one), created.user
    assert_redirected_to visit_report_url(created)
  end

  test "defaults the visit report's user to the current user when none is selected" do
    assert_difference("VisitReport.count") do
      post visit_reports_url, params: {
        visit_report: {
          care_recipient_id: care_recipients(:one).id,
          visit_type_id: visit_types(:one).id,
          notes: "verification note",
          status: "planned",
          "visited_at(1i)" => "2026", "visited_at(2i)" => "8", "visited_at(3i)" => "1",
          "visited_at(4i)" => "10", "visited_at(5i)" => "0"
        }
      }
    end

    assert_equal users(:one), VisitReport.last.user
  end

  test "should create visit_report with a start and end time" do
    assert_difference("VisitReport.count") do
      post visit_reports_url, params: {
        visit_report: {
          care_recipient_id: care_recipients(:one).id,
          visit_type_id: visit_types(:one).id,
          user_id: users(:staff_one).id,
          notes: "verification note",
          status: "planned",
          "visited_at(1i)" => "2026", "visited_at(2i)" => "8", "visited_at(3i)" => "1",
          "visited_at(4i)" => "10", "visited_at(5i)" => "0",
          "ended_at(1i)" => "2026", "ended_at(2i)" => "8", "ended_at(3i)" => "1",
          "ended_at(4i)" => "11", "ended_at(5i)" => "0"
        }
      }
    end

    created = VisitReport.last
    assert_equal 11, created.ended_at.hour
  end

  test "rejects an end time earlier than the start time" do
    assert_no_difference("VisitReport.count") do
      post visit_reports_url, params: {
        visit_report: {
          care_recipient_id: care_recipients(:one).id,
          visit_type_id: visit_types(:one).id,
          user_id: users(:staff_one).id,
          status: "planned",
          "visited_at(1i)" => "2026", "visited_at(2i)" => "8", "visited_at(3i)" => "1",
          "visited_at(4i)" => "10", "visited_at(5i)" => "0",
          "ended_at(1i)" => "2026", "ended_at(2i)" => "8", "ended_at(3i)" => "1",
          "ended_at(4i)" => "9", "ended_at(5i)" => "0"
        }
      }
    end
  end

  test "admin can destroy a visit_report" do
    assert_difference("VisitReport.count", -1) do
      delete visit_report_url(@visit_report)
    end
    assert_redirected_to calendar_care_recipient_path(@visit_report.care_recipient)
  end

  test "staff cannot destroy a visit_report" do
    sign_out users(:one)
    sign_in users(:staff_one)

    assert_no_difference("VisitReport.count") do
      delete visit_report_url(@visit_report)
    end
  end
end
