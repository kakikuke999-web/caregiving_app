require "test_helper"

class VisitReportTest < ActiveSupport::TestCase
  def build_report(attrs = {})
    VisitReport.new(
      {
        care_recipient: care_recipients(:one),
        visit_type: visit_types(:one),
        visited_at: Time.zone.now
      }.merge(attrs)
    )
  end

  test "valid with a user assigned" do
    assert build_report(user: users(:staff_one)).valid?
  end

  test "valid with only a provider_name (no internal user)" do
    assert build_report(provider_name: "ふれんず訪問看護ステーション").valid?
  end

  test "invalid without either a user or a provider_name" do
    assert_not build_report.valid?
  end

  test "assignee_label prefers the user's name over provider_name" do
    report = build_report(user: users(:staff_one), provider_name: "何かの事業者")
    assert_equal users(:staff_one).name, report.assignee_label
  end

  test "assignee_label falls back to provider_name when there is no user" do
    report = build_report(provider_name: "ふれんず訪問看護ステーション")
    assert_equal "ふれんず訪問看護ステーション", report.assignee_label
  end
end
