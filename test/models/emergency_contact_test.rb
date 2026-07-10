require "test_helper"

class EmergencyContactTest < ActiveSupport::TestCase
  test "valid with name and phone_number" do
    contact = EmergencyContact.new(care_recipient: care_recipients(:one), name: "田中一郎", phone_number: "090-0000-0000")
    assert contact.valid?
  end

  test "invalid without name" do
    contact = EmergencyContact.new(care_recipient: care_recipients(:one), phone_number: "090-0000-0000")
    assert_not contact.valid?
  end

  test "invalid without phone_number" do
    contact = EmergencyContact.new(care_recipient: care_recipients(:one), name: "田中一郎")
    assert_not contact.valid?
  end
end
