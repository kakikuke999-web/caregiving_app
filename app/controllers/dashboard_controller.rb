class DashboardController < ApplicationController
  STALE_THRESHOLD = 7.days

  def index
    authorize :dashboard, :index?, policy_class: DashboardPolicy

    @care_recipients = policy_scope(CareRecipient).order(:name)
    @mine_only = params[:mine].present?
    @care_recipients = @care_recipients.where(primary_care_manager_id: current_user.id) if @mine_only

    @recipient_rows = @care_recipients.map { |care_recipient| build_row(care_recipient) }

    visit_reports = VisitReport.where(care_recipient_id: @care_recipients.select(:id))
    @total_count = @recipient_rows.size
    @stale_count = @recipient_rows.count { |row| row[:stale] }
    @visits_today_count = visit_reports.where(status: :planned, visited_at: Time.zone.now.all_day).count
    @missed_visits_count = visit_reports.where(status: :missed).count
    @today_visits = visit_reports.where(status: :planned, visited_at: Time.zone.now.all_day)
                                  .includes(:care_recipient, :user)
                                  .order(:visited_at)
    @certification_alert_count = @recipient_rows.count { |row| row[:certification_expired] || row[:certification_expiring] }
    @monitoring_due_count = @recipient_rows.count { |row| !row[:monitored_this_month] }
  end

  private

  def build_row(care_recipient)
    last_recorded_at = [
      care_recipient.vitals.maximum(:recorded_at),
      care_recipient.adl_records.maximum(:recorded_at),
      care_recipient.medication_records.maximum(:recorded_at)
    ].compact.max

    next_visit = care_recipient.visit_reports
                                .where(status: :planned)
                                .where("visited_at >= ?", Time.current)
                                .order(:visited_at)
                                .first

    {
      care_recipient: care_recipient,
      last_recorded_at: last_recorded_at,
      stale: last_recorded_at.nil? || last_recorded_at < STALE_THRESHOLD.ago,
      next_visit: next_visit,
      missed_count: care_recipient.visit_reports.where(status: :missed).count,
      certification_expired: care_recipient.certification_expired?,
      certification_expiring: care_recipient.certification_expiring?,
      monitored_this_month: care_recipient.monitored_this_month?
    }
  end
end
