# 定期予定パターン（RecurringSchedule）から、実際の訪問記録（VisitReport, status: planned）を
# 一定期間分まとめて生成する。同じパターン・同じ日にすでに生成済みの記録があればスキップするため、
# 何度実行しても安全（重複登録されない）。
class RecurringScheduleGenerator
  DEFAULT_WEEKS_AHEAD = 8

  Result = Struct.new(:created, :skipped, keyword_init: true)

  def self.call(...)
    new(...).call
  end

  def initialize(care_recipient:, weeks_ahead: DEFAULT_WEEKS_AHEAD)
    @care_recipient = care_recipient
    @weeks_ahead = weeks_ahead
  end

  def call
    created = 0
    skipped = 0
    today = Time.zone.today
    last_day = today + (@weeks_ahead * 7)

    @care_recipient.recurring_schedules.active.find_each do |schedule|
      (today..last_day).each do |date|
        next unless date.wday == schedule.day_of_week

        visited_at = Time.zone.local(date.year, date.month, date.day, schedule.start_time.hour, schedule.start_time.min)

        if VisitReport.exists?(recurring_schedule_id: schedule.id, visited_at: visited_at)
          skipped += 1
          next
        end

        ended_at = if schedule.end_time.present?
          Time.zone.local(date.year, date.month, date.day, schedule.end_time.hour, schedule.end_time.min)
        end

        VisitReport.create!(
          care_recipient: @care_recipient,
          visit_type: schedule.visit_type,
          user: schedule.user,
          provider_name: schedule.provider_name,
          recurring_schedule: schedule,
          visited_at: visited_at,
          ended_at: ended_at,
          status: :planned
        )
        created += 1
      end
    end

    Result.new(created: created, skipped: skipped)
  end
end
