require "test_helper"

class MedicationRecordTest < ActiveSupport::TestCase
  test "valid with medication_name and recorded_at" do
    record = MedicationRecord.new(care_recipient: care_recipients(:one), recorded_by: users(:staff_one),
                                   recorded_at: Time.current, medication_name: "降圧剤")
    assert record.valid?
  end

  test "invalid without medication_name" do
    record = MedicationRecord.new(care_recipient: care_recipients(:one), recorded_by: users(:staff_one),
                                   recorded_at: Time.current)
    assert_not record.valid?
  end
end
