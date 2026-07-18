require "test_helper"

class AlertMailerTest < ActionMailer::TestCase
  test "daily_digest lists each flagged recipient and their reasons" do
    care_recipient = care_recipients(:one)
    care_recipient.update!(care_level_valid_until: 1.day.ago.to_date)

    user = users(:one)
    summary = AlertSummary.new(user)
    mail = AlertMailer.daily_digest(user, summary)

    assert_equal [user.email], mail.to
    assert_match(/要確認/, mail.subject)
    assert_match care_recipient.name, mail.html_part.body.to_s
    assert_match "認定期限切れ", mail.html_part.body.to_s
    assert_match care_recipient.name, mail.text_part.body.to_s
  end
end
