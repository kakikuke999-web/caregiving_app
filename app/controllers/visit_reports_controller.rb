class VisitReportsController < ApplicationController
  def index
    @visit_reports = policy_scope(VisitReport)
    if params[:care_recipient_id].present?
      @care_recipient = CareRecipient.find(params[:care_recipient_id])
      authorize @care_recipient, :show?
      @visit_reports = @visit_reports.where(care_recipient_id: @care_recipient.id)
    end
  end


  def show
    @visit_report = VisitReport.find(params[:id])
    authorize @visit_report
    @comment = Comment.new(visit_report: @visit_report)
  end

  def new
    @visit_report = VisitReport.new(care_recipient_id: params[:care_recipient_id])
    @visit_report.visited_at = Time.zone.parse(params[:visited_at]) if params[:visited_at].present?
    @visit_report.user_id = current_user.id
    @available_visit_types = available_visit_types_for(@visit_report.care_recipient)
    @visit_report.visit_type_id = @available_visit_types.first.id if @available_visit_types.count == 1
    authorize @visit_report
  end

  def create
    @visit_report = VisitReport.new(visit_report_params)
    @visit_report.user ||= current_user
    authorize @visit_report
    if @visit_report.save
      redirect_to @visit_report, notice: "訪問記録を登録しました"
    else
      @available_visit_types = available_visit_types_for(@visit_report.care_recipient)
      render :new, status: :unprocessable_entity
    end
  end

  def calendar_events
    care_recipient = CareRecipient.find(params[:id])
    authorize care_recipient, :show?

    reports = policy_scope(VisitReport).includes(:user, :visit_type).where(care_recipient_id: care_recipient.id)
    render json: reports.map { |report| event_json(report) }
  end

  def calendar_events_all
    reports = policy_scope(VisitReport).includes(:user, :visit_type, :care_recipient)
    render json: reports.map { |report| event_json(report, include_recipient_name: true) }
  end

  def edit
    @report = VisitReport.find(params[:id])
    @available_visit_types = available_visit_types_for(@report.care_recipient)
    authorize @report
  end

  def update
    @report = VisitReport.find(params[:id])
    authorize @report
    if @report.update(visit_report_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("calendar", partial: "calendar", locals: { care_recipient: @report.care_recipient })
        end
        format.html { redirect_to calendar_care_recipient_path(@report.care_recipient), notice: '更新しました' }
      end
    else
      @available_visit_types = available_visit_types_for(@report.care_recipient)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report = VisitReport.find(params[:id])
    authorize @report
    care_recipient = @report.care_recipient
    @report.destroy!
    redirect_to calendar_care_recipient_path(care_recipient), notice: "訪問記録を削除しました"
  end

  STATUS_COLORS = {
    "planned" => "#2a78d6",
    "completed" => "#0ca30c",
    "missed" => "#d03b3b"
  }.freeze

  STATUS_LABELS = {
    "planned" => "予定",
    "completed" => "完了",
    "missed" => "未実施"
  }.freeze

  private

  def visit_report_params
    params.require(:visit_report).permit(:care_recipient_id, :visited_at, :ended_at, :user_id, :visit_type_id, :notes, :status)
  end

  def available_visit_types_for(care_recipient)
    return VisitType.order(:name) if care_recipient.nil?

    linked = care_recipient.visit_types.order(:name)
    linked.any? ? linked : VisitType.order(:name)
  end

  def event_json(report, include_recipient_name: false)
    visit_type_name = report.visit_type&.name || "未分類"
    title = include_recipient_name ? "#{report.care_recipient.name}: #{visit_type_name}（#{report.user.name}）" : "#{visit_type_name}（#{report.user.name}）"

    {
      title: title,
      start: report.visited_at,
      end: report.ended_at,
      color: STATUS_COLORS[report.status],
      extendedProps: {
        id: report.id,
        staff_name: report.user.name,
        visit_type: visit_type_name,
        details: report.notes,
        status: report.status,
        status_label: STATUS_LABELS[report.status],
        care_recipient_name: report.care_recipient.name
      }
    }
  end
end
