require "test_helper"

class AdlRecordTest < ActiveSupport::TestCase
  test "valid with recorded_at and enum fields" do
    record = AdlRecord.new(care_recipient: care_recipients(:one), recorded_by: users(:staff_one),
                            recorded_at: Time.current, meal_intake: :full, excretion_status: :normal,
                            sleep_quality: :good)
    assert record.valid?
  end

  test "invalid without recorded_at" do
    record = AdlRecord.new(care_recipient: care_recipients(:one), recorded_by: users(:staff_one))
    assert_not record.valid?
  end
end
