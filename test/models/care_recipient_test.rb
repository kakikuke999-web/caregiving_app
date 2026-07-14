require "test_helper"

class CareRecipientTest < ActiveSupport::TestCase
  test "certification_expired? and certification_expiring?" do
    recipient = care_recipients(:one)

    recipient.care_level_valid_until = nil
    assert_not recipient.certification_expired?
    assert_not recipient.certification_expiring?

    recipient.care_level_valid_until = 1.day.ago.to_date
    assert recipient.certification_expired?
    assert_not recipient.certification_expiring?

    recipient.care_level_valid_until = 30.days.from_now.to_date
    assert_not recipient.certification_expired?
    assert recipient.certification_expiring?

    recipient.care_level_valid_until = 1.year.from_now.to_date
    assert_not recipient.certification_expired?
    assert_not recipient.certification_expiring?
  end

  test "care_level must be one of the standard certification levels" do
    recipient = care_recipients(:one)

    recipient.care_level = "適当な値"
    assert_not recipient.valid?

    recipient.care_level = "要介護3"
    assert recipient.valid?

    recipient.care_level = ""
    assert recipient.valid?
  end

  test "monitored_this_month? checks for a completed monitoring visit in the current month" do
    recipient = care_recipients(:one)
    assert_not recipient.monitored_this_month?

    VisitReport.create!(care_recipient: recipient, user: users(:staff_one), visit_type: visit_types(:one),
                         visited_at: Time.current, status: :planned, is_monitoring: true)
    assert_not recipient.monitored_this_month?, "a planned (not completed) monitoring visit should not count"

    VisitReport.create!(care_recipient: recipient, user: users(:staff_one), visit_type: visit_types(:one),
                         visited_at: Time.current, status: :completed, is_monitoring: false)
    assert_not recipient.monitored_this_month?, "a completed visit not flagged as monitoring should not count"

    VisitReport.create!(care_recipient: recipient, user: users(:staff_one), visit_type: visit_types(:one),
                         visited_at: Time.current, status: :completed, is_monitoring: true)
    assert recipient.monitored_this_month?
  end
end
