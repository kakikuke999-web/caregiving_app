require "test_helper"

class VitalTest < ActiveSupport::TestCase
  test "valid with numeric value" do
    vital = Vital.new(care_recipient: care_recipients(:one), recorded_by: users(:staff_one),
                       recorded_at: Time.current, type: "pulse", value: 70)
    assert vital.valid?
  end

  test "blood pressure requires systolic and diastolic instead of value" do
    vital = Vital.new(care_recipient: care_recipients(:one), recorded_by: users(:staff_one),
                       recorded_at: Time.current, type: "blood_pressure")
    assert_not vital.valid?
    assert_includes vital.errors.attribute_names, :systolic
    assert_includes vital.errors.attribute_names, :diastolic

    vital.systolic = 120
    vital.diastolic = 80
    assert vital.valid?
  end

  test "rejects unknown type" do
    vital = Vital.new(care_recipient: care_recipients(:one), recorded_by: users(:staff_one),
                       recorded_at: Time.current, type: "unknown", value: 1)
    assert_not vital.valid?
  end
end
