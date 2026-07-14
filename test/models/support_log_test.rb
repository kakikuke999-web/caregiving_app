require "test_helper"

class SupportLogTest < ActiveSupport::TestCase
  test "valid with a known category, occurred_at, and body" do
    log = SupportLog.new(care_recipient: care_recipients(:one), user: users(:staff_one),
                          category: "phone", occurred_at: Time.current, body: "電話対応")
    assert log.valid?
  end

  test "invalid with an unknown category" do
    log = SupportLog.new(care_recipient: care_recipients(:one), user: users(:staff_one),
                          category: "unknown", occurred_at: Time.current, body: "内容")
    assert_not log.valid?
  end

  test "invalid without a body" do
    log = SupportLog.new(care_recipient: care_recipients(:one), user: users(:staff_one),
                          category: "phone", occurred_at: Time.current)
    assert_not log.valid?
  end

  test "orders newest first by default" do
    care_recipients(:one).support_logs.destroy_all
    older = SupportLog.create!(care_recipient: care_recipients(:one), user: users(:staff_one),
                                category: "phone", occurred_at: 2.days.ago, body: "古い記録")
    newer = SupportLog.create!(care_recipient: care_recipients(:one), user: users(:staff_one),
                                category: "phone", occurred_at: 1.day.ago, body: "新しい記録")

    assert_equal [newer, older], SupportLog.where(care_recipient: care_recipients(:one)).to_a
  end
end
