# 紙の日誌をまとめてデジタル化するための管理者向け一括インポート。
# JSON配列を受け取り、1レコードにつき訪問記録・バイタル・ADL記録を作成する。
# 同じ日時の訪問記録が既にある場合はスキップするため、複数回実行しても安全。
class DailyReportBulkImport
  Result = Struct.new(:created, :skipped, :errors, keyword_init: true)

  DAY_SERVICE_VISIT_TYPE_NAME = "デイサービス".freeze

  def self.call(...)
    new(...).call
  end

  def initialize(care_recipient:, json:)
    @care_recipient = care_recipient
    @json = json
  end

  def call
    records = JSON.parse(@json, symbolize_names: true)
    visit_type = VisitType.find_by(name: DAY_SERVICE_VISIT_TYPE_NAME)
    fallback_user = User.where(role: :admin).order(:id).first

    created = 0
    skipped = 0
    errors = []

    records.each do |r|
      visited_at = Time.zone.parse("#{r[:date]} 10:00")

      if @care_recipient.visit_reports.exists?(visited_at: visited_at)
        skipped += 1
        next
      end

      user = r[:recorder_email].present? ? User.find_by(email: r[:recorder_email]) : nil
      user ||= fallback_user

      ActiveRecord::Base.transaction do
        @care_recipient.visit_reports.create!(
          user: user, visit_type: visit_type, visited_at: visited_at,
          status: :completed, notes: r[:notes]
        )

        if r[:temperature].present?
          @care_recipient.vitals.create!(type: "temperature", value: r[:temperature], recorded_by: user, recorded_at: visited_at)
        end

        Array(r[:blood_pressures]).each_with_index do |(systolic, diastolic), i|
          @care_recipient.vitals.create!(type: "blood_pressure", systolic: systolic, diastolic: diastolic, recorded_by: user, recorded_at: visited_at + i.hours)
        end

        Array(r[:pulses]).each_with_index do |value, i|
          @care_recipient.vitals.create!(type: "pulse", value: value, recorded_by: user, recorded_at: visited_at + i.hours)
        end

        @care_recipient.adl_records.create!(
          recorded_by: user, recorded_at: visited_at,
          bathed: r[:bathed], medication_taken: r[:medication_taken],
          urination_count: r[:urination_count], bowel_movement: r[:bowel_movement],
          lunch_staple: r[:lunch_staple], lunch_side: r[:lunch_side]
        )
      end

      created += 1
    rescue StandardError => e
      errors << "#{r[:date]}: #{e.message}"
    end

    Result.new(created: created, skipped: skipped, errors: errors)
  end
end
