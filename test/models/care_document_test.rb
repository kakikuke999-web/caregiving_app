require "test_helper"

class CareDocumentTest < ActiveSupport::TestCase
  def build_document(attrs = {})
    CareDocument.new(
      {
        care_recipient: care_recipients(:one),
        uploaded_by: users(:one),
        document_type: "care_plan"
      }.merge(attrs)
    )
  end

  test "requires a valid document_type" do
    doc = build_document(document_type: "unknown")
    doc.file.attach(io: StringIO.new("x"), filename: "x.txt", content_type: "text/plain")
    assert_not doc.valid?
  end

  test "requires a file to be attached" do
    doc = build_document
    assert_not doc.valid?
    assert_includes doc.errors[:file], "を選択してください"
  end

  test "rejects a valid_until before valid_from" do
    doc = build_document(valid_from: Date.new(2026, 1, 1), valid_until: Date.new(2025, 12, 31))
    doc.file.attach(io: StringIO.new("x"), filename: "x.txt", content_type: "text/plain")
    assert_not doc.valid?
  end

  test "label returns the Japanese name for the type" do
    doc = build_document(document_type: "rehab_plan")
    assert_equal "リハビリテーション実施計画書", doc.label
  end
end
