require "test_helper"

class AlertSummaryTest < ActiveSupport::TestCase
  test "flags certification expiry, staleness, and missed visits" do
    care_recipient = care_recipients(:one)
    care_recipient.update!(care_level_valid_until: 1.day.ago.to_date)
    VisitReport.create!(care_recipient: care_recipient, user: users(:staff_one), visit_type: visit_types(:one),
                         visited_at: 1.day.ago, status: :missed)

    summary = AlertSummary.new(users(:one))
    row = summary.rows.find { |r| r.care_recipient == care_recipient }

    assert row, "expected an alert row for the recipient"
    assert_includes row.messages, "認定期限切れ"
    assert(row.messages.any? { |m| m.include?("モニタリング") })
    assert(row.messages.any? { |m| m.include?("未実施の訪問") })
  end

  test "a recipient with nothing to flag does not appear in rows" do
    care_recipient = care_recipients(:one)
    care_recipient.update!(care_level_valid_until: 1.year.from_now.to_date)
    VisitReport.create!(care_recipient: care_recipient, user: users(:staff_one), visit_type: visit_types(:one),
                         visited_at: Time.current, status: :completed, is_monitoring: true)
    care_recipient.vitals.create!(type: "pulse", value: 70, recorded_by: users(:staff_one), recorded_at: Time.current)

    summary = AlertSummary.new(users(:one))
    assert_not_includes summary.rows.map(&:care_recipient), care_recipient
  end

  test "family only sees their linked recipient's alerts" do
    care_recipients(:one).update!(care_level_valid_until: 1.day.ago.to_date)
    care_recipients(:two).update!(care_level_valid_until: 1.day.ago.to_date)

    summary = AlertSummary.new(users(:family_one))
    assert_equal [care_recipients(:one)], summary.rows.map(&:care_recipient)
  end
end
