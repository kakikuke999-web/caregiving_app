class DashboardController < ApplicationController
  def index
    authorize :dashboard, :index?, policy_class: DashboardPolicy

    @care_recipients = policy_scope(CareRecipient).order(:name)
    @mine_only = params[:mine].present?
    @care_recipients = @care_recipients.where(primary_care_manager_id: current_user.id) if @mine_only

    stats = recipient_stats(@care_recipients)
    @recipient_rows = @care_recipients.map { |care_recipient| build_row(care_recipient, stats) }

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

  # Batches the per-recipient dashboard numbers into a handful of grouped
  # queries instead of ~6 queries per recipient (was a real N+1 on the
  # main landing page as soon as more than one recipient exists).
  def recipient_stats(care_recipients)
    ids = care_recipients.map(&:id)

    last_vitals = Vital.where(care_recipient_id: ids).group(:care_recipient_id).maximum(:recorded_at)
    last_adl = AdlRecord.where(care_recipient_id: ids).group(:care_recipient_id).maximum(:recorded_at)
    last_medication = MedicationRecord.where(care_recipient_id: ids).group(:care_recipient_id).maximum(:recorded_at)

    next_visits = VisitReport.where(care_recipient_id: ids, status: :planned)
                              .where("visited_at >= ?", Time.current)
                              .order(:visited_at)
                              .group_by(&:care_recipient_id)
                              .transform_values(&:first)

    missed_counts = VisitReport.where(care_recipient_id: ids, status: :missed)
                                .group(:care_recipient_id).count

    monitored_ids = VisitReport.where(care_recipient_id: ids, is_monitoring: true, status: :completed,
                                       visited_at: Time.zone.now.all_month)
                                .distinct.pluck(:care_recipient_id).to_set

    ids.index_with do |id|
      last_recorded_at = [last_vitals[id], last_adl[id], last_medication[id]].compact.max

      {
        last_recorded_at: last_recorded_at,
        stale: last_recorded_at.nil? || last_recorded_at < CareRecipient::STALE_THRESHOLD.ago,
        next_visit: next_visits[id],
        missed_count: missed_counts[id] || 0,
        monitored_this_month: monitored_ids.include?(id)
      }
    end
  end

  def build_row(care_recipient, stats)
    s = stats[care_recipient.id]

    {
      care_recipient: care_recipient,
      last_recorded_at: s[:last_recorded_at],
      stale: s[:stale],
      next_visit: s[:next_visit],
      missed_count: s[:missed_count],
      certification_expired: care_recipient.certification_expired?,
      certification_expiring: care_recipient.certification_expiring?,
      monitored_this_month: s[:monitored_this_month]
    }
  end
end
