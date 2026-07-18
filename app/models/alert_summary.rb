# ダッシュボードの警告バッジ・メール通知(AlertMailer)の両方から使う、
# 「この対象者について今すぐ確認すべきこと」の一覧。単一の判定ロジックを両方が参照することで、
# 画面とメールの内容が食い違わないようにする。
class AlertSummary
  Row = Struct.new(:care_recipient, :messages, keyword_init: true)

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def care_recipients
    @care_recipients ||= CareRecipientPolicy::Scope.new(user, CareRecipient).resolve.order(:name)
  end

  def rows
    @rows ||= care_recipients.map { |care_recipient| build_row(care_recipient) }.select { |row| row.messages.any? }
  end

  def any?
    rows.any?
  end

  private

  def build_row(care_recipient)
    messages = []
    messages << "認定期限切れ" if care_recipient.certification_expired?
    messages << "認定期限がまもなく切れます(#{care_recipient.care_level_valid_until})" if care_recipient.certification_expiring?
    messages << "7日以上記録がありません" if care_recipient.stale?
    messages << "今月のモニタリング記録が未実施です" unless care_recipient.monitored_this_month?

    missed = care_recipient.missed_visit_count
    messages << "未実施の訪問が#{missed}件あります" if missed.positive?

    Row.new(care_recipient: care_recipient, messages: messages)
  end
end
