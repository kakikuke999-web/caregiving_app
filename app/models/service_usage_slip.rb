# 月間のサービス利用票（予定・実績の日別グリッド）を、既存の VisitReport から組み立てる。
# 訪問タイプ×担当（自社スタッフ/外部事業者）の組み合わせごとに1行とする。
class ServiceUsageSlip
  Row = Struct.new(:visit_type_name, :assignee, :unit_count, :scheduled_days, :completed_days, keyword_init: true)

  attr_reader :care_recipient, :month

  def initialize(care_recipient:, month:)
    @care_recipient = care_recipient
    @month = month
  end

  def rows
    reports = care_recipient.visit_reports.where(visited_at: month.all_month).includes(:visit_type)

    reports.group_by { |r| [r.visit_type&.name || "未分類", r.assignee_label] }
           .map do |(type_name, assignee), group_reports|
      Row.new(
        visit_type_name: type_name,
        assignee: assignee,
        unit_count: group_reports.first.visit_type&.unit_count,
        scheduled_days: group_reports.map { |r| r.visited_at.day }.uniq.sort,
        completed_days: group_reports.select(&:completed?).map { |r| r.visited_at.day }.uniq.sort
      )
    end.sort_by { |row| [row.visit_type_name, row.assignee.to_s] }
  end
end
