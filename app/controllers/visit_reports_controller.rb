class VisitReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_edit, only: [:new, :create, :edit, :update]



  def authorize_edit
    redirect_to root_path, alert: "権限がありません" if current_user.family?
  end

  def index
    if params[:care_recipient_id].present?
      @care_recipient = CareRecipient.find(params[:care_recipient_id])
      @visit_reports = VisitReport.where(care_recipient_id: @care_recipient.id)
    else
      @visit_reports = VisitReport.all
    end
  end


  def show
    @visit_report = VisitReport.find(params[:id])
  end

  def new
    @visit_report = VisitReport.new(care_recipient_id: params[:care_recipient_id])

  end

  def create
    @visit_report = VisitReport.new(visit_report_params)
    @visit_report.user = current_user
    if @visit_report.save
      redirect_to @visit_report, notice: "訪問記録を登録しました"
    else
      render :new
    end
  end

  def calendar_events
    reports = VisitReport.includes(:user, :visit_type).where(care_recipient_id: params[:id])

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
  end

  def update
    @report = VisitReport.find(params[:id])
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
