require "test_helper"

class CareDocumentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @care_recipient = care_recipients(:one)
    @care_document = care_documents(:one)
  end

  test "staff can upload a care document" do
    sign_in users(:staff_one)

    assert_difference("CareDocument.count") do
      post care_recipient_care_documents_url(@care_recipient), params: {
        care_document: {
          document_type: "rehab_plan",
          title: "リハビリテーション実施計画書",
          issuing_organization: "豊郷病院",
          issued_on: "2025-09-11",
          file: fixture_file_upload("sample_document.txt", "text/plain")
        }
      }
    end

    doc = CareDocument.last
    assert_equal users(:staff_one), doc.uploaded_by
    assert doc.file.attached?
    assert_redirected_to care_recipient_care_documents_url(@care_recipient)
  end

  test "family can view but not upload or destroy care documents" do
    sign_in users(:family_one)

    get care_recipient_care_documents_url(@care_recipient)
    assert_response :success

    assert_no_difference("CareDocument.count") do
      post care_recipient_care_documents_url(@care_recipient), params: {
        care_document: { document_type: "other", file: fixture_file_upload("sample_document.txt", "text/plain") }
      }
    end

    assert_no_difference("CareDocument.count") do
      delete care_recipient_care_document_url(@care_recipient, @care_document)
    end
  end

  test "staff cannot destroy but admin can" do
    sign_in users(:staff_one)
    assert_no_difference("CareDocument.count") do
      delete care_recipient_care_document_url(@care_recipient, @care_document)
    end

    sign_out users(:staff_one)
    sign_in users(:one)
    assert_difference("CareDocument.count", -1) do
      delete care_recipient_care_document_url(@care_recipient, @care_document)
    end
  end
end
