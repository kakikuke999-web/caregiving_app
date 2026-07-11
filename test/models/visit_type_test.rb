require "test_helper"

class VisitTypeTest < ActiveSupport::TestCase
  test "valid with a unique name" do
    visit_type = VisitType.new(name: "ユニークな訪問タイプ")
    assert visit_type.valid?
  end

  test "invalid without a name" do
    visit_type = VisitType.new(name: nil)
    assert_not visit_type.valid?
  end

  test "invalid with a duplicate name" do
    VisitType.create!(name: "重複タイプ")
    duplicate = VisitType.new(name: "重複タイプ")
    assert_not duplicate.valid?
  end

  test "cannot be destroyed while visit_reports reference it" do
    visit_type = VisitType.create!(name: "使用中タイプ")
    VisitReport.create!(care_recipient: care_recipients(:one), user: users(:staff_one), visit_type: visit_type,
                         visited_at: Time.current, status: :planned)

    assert_not visit_type.destroy
    assert visit_type.errors.any?
  end
end
