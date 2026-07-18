class AlertNotificationsController < ApplicationController
  # 外部の無料cronサービス(セッションを持たない)から呼ばれるため、通常のログイン認証・
  # CSRFトークン検証の対象外にし、代わりに共有シークレット(ALERT_NOTIFICATION_SECRET)で認証する。
  skip_before_action :authenticate_user!, only: [:trigger]
  skip_before_action :verify_authenticity_token, only: [:trigger]

  def trigger
    secret = ENV["ALERT_NOTIFICATION_SECRET"]

    if secret.present? && ActiveSupport::SecurityUtils.secure_compare(params[:token].to_s, secret)
      results = AlertDigestSender.call
      render json: { sent: results.count(&:sent) }, status: :ok
    else
      head :unauthorized
    end
  end

  def send_test
    authorize :alert_notification, :send_test?, policy_class: AlertNotificationPolicy

    result = AlertDigestSender.call(users: [current_user], force: true).first
    if result.sent
      redirect_to dashboard_path, notice: "テストメールを送信しました(#{current_user.email})"
    else
      redirect_to dashboard_path, alert: test_failure_message(result.reason)
    end
  end

  private

  def test_failure_message(reason)
    case reason
    when :opted_out
      "メール通知がオフになっています。ユーザー編集画面でオンにしてください。"
    when :no_alerts
      "現在、確認が必要な対象者はありません。"
    else
      "送信できませんでした。"
    end
  end
end
