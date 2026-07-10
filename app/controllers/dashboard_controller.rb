class DashboardController < ApplicationController
  STALE_THRESHOLD = 7.days

  def index
    authorize :dashboard, :index?, policy_class: DashboardPolicy

    @care_recipients = policy_scope(CareRecipient).order(:name)
    @recipient_rows = @care_recipients.map { |care_recipient| build_row(care_recipient) }

    visit_reports = VisitReport.where(care_recipient_id: @care_recipients.select(:id))
    @total_count = @recipient_rows.size
    @stale_count = @recipient_rows.count { |row| row[:stale] }
    @visits_today_count = visit_reports.where(status: :planned, visited_at: Time.zone.now.all_day).count
    @missed_visits_count = visit_reports.where(status: :missed).count
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
      missed_count: care_recipient.visit_reports.where(status: :missed).count
    }
  end
end
