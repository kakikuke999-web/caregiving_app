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
  end

  def new
    @visit_report = VisitReport.new(care_recipient_id: params[:care_recipient_id])
    authorize @visit_report
  end

  def create
    @visit_report = VisitReport.new(visit_report_params)
    @visit_report.user = current_user
    authorize @visit_report
    if @visit_report.save
      redirect_to @visit_report, notice: "訪問記録を登録しました"
    else
      render :new
    end
  end

  def calendar_events
    care_recipient = CareRecipient.find(params[:id])
    authorize care_recipient, :show?

    reports = policy_scope(VisitReport).includes(:user, :visit_type).where(care_recipient_id: care_recipient.id)

    events = reports.map do |report|
      {
        title: "#{report.visit_type.name}（#{report.user.name}）",
        start: report.visited_at,
        color: color_for(report), # ✅ 色分けロジックを活かす
        extendedProps: {
          id: report.id, 
          staff_name: report.user.name,
          visit_type: report.visit_type.name,
          details: report.notes
        }
      }
    end

    render json: events
  end


  def edit
    @report = VisitReport.find(params[:id])
    authorize @report
  end

  def update
    @report = VisitReport.find(params[:id])
    authorize @report
    if @report.update(report_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("calendar", partial: "calendar", locals: { care_recipient: @report.care_recipient })
        end
        format.html { redirect_to calendar_care_recipient_path(@report.care_recipient), notice: '更新しました' }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end



  private

  def report_params
    params.require(:visit_report).permit(:visited_at, :user_id, :visit_type_id, :notes, :status)
  end


  def color_for(report)
    case report.user.role
    when "care_manager" then "#1E90FF"
    when "staff" then "#32CD32"
    when "family" then "#FF69B4"
    else "#CCCCCC"
    end
  end

end
