# 対象ユーザー(admin/care_manager)に、その人が確認すべきアラートがあればダイジェストメールを送る。
# 1日1回だけ送るための重複防止(last_alert_email_sent_on)を内包しているので、
# 外部cronから複数回叩かれても安全。
class AlertDigestSender
  Result = Struct.new(:user, :sent, :reason, keyword_init: true)

  def self.call(users: User.where(role: %i[admin care_manager]), force: false)
    new(users: users, force: force).call
  end

  def initialize(users:, force: false)
    @users = users
    @force = force
  end

  def call
    @users.map { |user| send_to(user) }
  end

  private

  def send_to(user)
    return Result.new(user: user, sent: false, reason: :opted_out) unless user.alert_emails_enabled?
    return Result.new(user: user, sent: false, reason: :already_sent_today) if already_sent_today?(user)

    summary = AlertSummary.new(user)
    return Result.new(user: user, sent: false, reason: :no_alerts) unless summary.any?

    AlertMailer.daily_digest(user, summary).deliver_now
    user.update!(last_alert_email_sent_on: Date.current)
    Result.new(user: user, sent: true, reason: :sent)
  end

  def already_sent_today?(user)
    return false if @force

    user.last_alert_email_sent_on == Date.current
  end
end
