require "test_helper"

class ServiceUsageSlipPolicyTest < ActiveSupport::TestCase
  test "admin, care_manager, and staff can view" do
    assert ServiceUsageSlipPolicy.new(users(:one), care_recipients(:one)).show?
    assert ServiceUsageSlipPolicy.new(users(:care_manager_one), care_recipients(:one)).show?
    assert ServiceUsageSlipPolicy.new(users(:staff_one), care_recipients(:one)).show?
  end

  test "family cannot view (billing-adjacent internal document)" do
    assert_not ServiceUsageSlipPolicy.new(users(:family_one), care_recipients(:one)).show?
  end
end
