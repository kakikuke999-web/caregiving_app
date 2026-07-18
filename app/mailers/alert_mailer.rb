class AlertMailer < ApplicationMailer
  def daily_digest(user, summary)
    @user = user
    @rows = summary.rows

    mail(to: user.email, subject: "【ケアギビング】要確認の対象者が#{@rows.size}件あります")
  end
end
