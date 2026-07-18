require "test_helper"

class DailyReportPolicyTest < ActiveSupport::TestCase
  test "admin, care_manager, and staff can create" do
    assert DailyReportPolicy.new(users(:one), care_recipients(:one)).create?
    assert DailyReportPolicy.new(users(:care_manager_one), care_recipients(:one)).create?
    assert DailyReportPolicy.new(users(:staff_one), care_recipients(:one)).create?
  end

  test "family cannot create a daily report" do
    assert_not DailyReportPolicy.new(users(:family_one), care_recipients(:one)).create?
  end
end
