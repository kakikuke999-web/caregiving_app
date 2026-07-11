require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @visit_report = visit_reports(:one) # care_recipient: one
  end

  test "staff can comment on a visit report" do
    sign_in users(:staff_one)

    assert_difference("Comment.count") do
      post visit_report_comments_url(@visit_report), params: { comment: { body: "経過を共有します" } }
    end

    assert_equal users(:staff_one), Comment.last.user
    assert_redirected_to visit_report_url(@visit_report)
  end

  test "family can comment on their own linked recipient's visit report" do
    sign_in users(:family_one)

    assert_difference("Comment.count") do
      post visit_report_comments_url(@visit_report), params: { comment: { body: "ありがとうございます" } }
    end
  end

  test "family cannot comment on an unrelated recipient's visit report" do
    sign_in users(:family_two)

    assert_no_difference("Comment.count") do
      post visit_report_comments_url(@visit_report), params: { comment: { body: "無関係な投稿" } }
    end
  end

  test "rejects a blank comment" do
    sign_in users(:staff_one)

    assert_no_difference("Comment.count") do
      post visit_report_comments_url(@visit_report), params: { comment: { body: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "comment author can destroy their own comment" do
    sign_in users(:staff_one)
    comment = @visit_report.comments.create!(user: users(:staff_one), body: "削除予定")

    assert_difference("Comment.count", -1) do
      delete visit_report_comment_url(@visit_report, comment)
    end
  end

  test "another staff member cannot destroy someone else's comment" do
    sign_in users(:staff_one)
    comment = @visit_report.comments.create!(user: users(:one), body: "他人のコメント")

    assert_no_difference("Comment.count") do
      delete visit_report_comment_url(@visit_report, comment)
    end
  end

  test "care_manager can destroy any comment" do
    sign_in users(:care_manager_one)
    comment = @visit_report.comments.create!(user: users(:staff_one), body: "削除される")

    assert_difference("Comment.count", -1) do
      delete visit_report_comment_url(@visit_report, comment)
    end
  end
end
