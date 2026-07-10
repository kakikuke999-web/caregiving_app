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
