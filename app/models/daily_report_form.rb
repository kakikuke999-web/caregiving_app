# 紙の訪問日誌1枚分（バイタル・食事・排泄・入浴・服薬）をまとめて登録するための
# フォームオブジェクト。保存すると訪問記録・バイタル・ADL記録を1件ずつ生成する
# （DBには専用テーブルを持たない）。訪問タイプは呼び出し側が選択したものを使う
# ため、デイサービスに限らずどの訪問タイプでも使える。
class DailyReportForm
  include ActiveModel::Model

  attr_accessor :care_recipient, :recorded_by, :visit_type_id, :visited_at, :temperature,
                :systolic, :diastolic, :pulse, :urination_count,
                :lunch_staple, :lunch_side, :notes
  attr_reader :bathed, :medication_taken, :bowel_movement
  attr_reader :visit_report

  validates :visited_at, :visit_type_id, :care_recipient, :recorded_by, presence: true
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
      recorded_at = visited_at.is_a?(Time) ? visited_at : Time.zone.parse(visited_at.to_s)

      @visit_report = care_recipient.visit_reports.create!(
        user: recorded_by,
        visit_type_id: visit_type_id,
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
