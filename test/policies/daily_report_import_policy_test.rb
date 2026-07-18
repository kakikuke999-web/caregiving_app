require "test_helper"

class DailyReportImportPolicyTest < ActiveSupport::TestCase
  test "only admin can bulk-import, not care_manager or staff" do
    assert DailyReportImportPolicy.new(users(:one), care_recipients(:one)).create?
    assert_not DailyReportImportPolicy.new(users(:care_manager_one), care_recipients(:one)).create?
    assert_not DailyReportImportPolicy.new(users(:staff_one), care_recipients(:one)).create?
  end
end
