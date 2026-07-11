# 紙のデイサービス日誌1枚分をまとめて登録するためのフォームオブジェクト。
# 保存すると訪問記録・バイタル・ADL記録を1件ずつ生成する（DBには専用テーブルを持たない）。
class DailyReportForm
  include ActiveModel::Model

  DAY_SERVICE_VISIT_TYPE_NAME = "デイサービス".freeze

  attr_accessor :care_recipient, :recorded_by, :visited_on, :temperature,
                :systolic, :diastolic, :pulse, :urination_count,
                :lunch_staple, :lunch_side, :notes
  attr_reader :bathed, :medication_taken, :bowel_movement
  attr_reader :visit_report

  validates :visited_on, :care_recipient, :recorded_by, presence: true
  validate :blood_pressure_requires_both_values

  def bathed=(value)
    @bathed = ActiveModel::Type::Boolean.new.cast(value)
  end

  def medication_taken=(value)
    @medication_taken = ActiveModel::Type::Boolean.new.cast(value)
  end

  def bowel_movement=(value)
    @bowel_movement = ActiveModel::Type::Boolean.new.cast(value)
  end

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      date = visited_on.is_a?(Date) ? visited_on : Date.parse(visited_on.to_s)
      recorded_at = Time.zone.local(date.year, date.month, date.day, 10)

      @visit_report = care_recipient.visit_reports.create!(
        user: recorded_by,
        visit_type: VisitType.find_by(name: DAY_SERVICE_VISIT_TYPE_NAME),
        visited_at: recorded_at,
        status: :completed,
        notes: notes
      )

      if temperature.present?
        care_recipient.vitals.create!(type: "temperature", value: temperature, recorded_by: recorded_by, recorded_at: recorded_at)
      end

      if systolic.present? && diastolic.present?
        care_recipient.vitals.create!(type: "blood_pressure", systolic: systolic, diastolic: diastolic, recorded_by: recorded_by, recorded_at: recorded_at)
      end

      if pulse.present?
        care_recipient.vitals.create!(type: "pulse", value: pulse, recorded_by: recorded_by, recorded_at: recorded_at)
      end

      care_recipient.adl_records.create!(
        recorded_by: recorded_by,
        recorded_at: recorded_at,
        bathed: bathed,
        medication_taken: medication_taken,
        urination_count: urination_count,
        bowel_movement: bowel_movement,
        lunch_staple: lunch_staple,
        lunch_side: lunch_side
      )
    end

    true
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    false
  end

  private

  def blood_pressure_requires_both_values
    return if systolic.present? == diastolic.present?

    errors.add(:base, "血圧は上下ともに入力してください")
  end
end
