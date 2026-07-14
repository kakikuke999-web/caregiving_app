class SupportLogsController < ApplicationController
  before_action :set_care_recipient
  before_action :set_support_log, only: %i[edit update destroy]

  def index
    authorize SupportLog.new(care_recipient: @care_recipient)
    @support_logs = @care_recipient.support_logs
  end

  def new
    @support_log = @care_recipient.support_logs.new(occurred_at: Time.current)
    authorize @support_log
  end

  def create
    @support_log = @care_recipient.support_logs.new(support_log_params)
    @support_log.user = current_user
    authorize @support_log

    if @support_log.save
      redirect_to care_recipient_support_logs_path(@care_recipient), notice: "支援経過記録を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @support_log
  end

  def update
    authorize @support_log

    if @support_log.update(support_log_params)
      redirect_to care_recipient_support_logs_path(@care_recipient), notice: "支援経過記録を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @support_log
    @support_log.destroy!
    redirect_to care_recipient_support_logs_path(@care_recipient), notice: "支援経過記録を削除しました"
  end

  private

  def set_care_recipient
    @care_recipient = CareRecipient.find(params[:care_recipient_id])
  end

  def set_support_log
    @support_log = @care_recipient.support_logs.find(params[:id])
  end

  def support_log_params
    params.require(:support_log).permit(:category, :occurred_at, :body)
  end
end
