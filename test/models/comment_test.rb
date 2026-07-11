require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "requires a body" do
    comment = Comment.new(visit_report: visit_reports(:one), user: users(:one), body: "")
    assert_not comment.valid?
  end
end
