require "test_helper"

class MedicationRecordPolicyTest < ActiveSupport::TestCase
  test "staff can create and update but not destroy" do
    policy = MedicationRecordPolicy.new(users(:staff_one), medication_records(:one))
    assert policy.create?
    assert policy.update?
    assert_not policy.destroy?
  end

  test "family can view own recipient's records but not create" do
    policy = MedicationRecordPolicy.new(users(:family_one), medication_records(:one))
    assert policy.show?
    assert_not policy.create?
  end

  test "family cannot view other recipient's records" do
    policy = MedicationRecordPolicy.new(users(:family_one), medication_records(:two))
    assert_not policy.show?
  end
end
