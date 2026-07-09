class AdlRecordsController < ApplicationController
  before_action :set_care_recipient
  before_action :set_adl_record, only: %i[edit update destroy]

  def index
    authorize @care_recipient, :show?
    @adl_records = @care_recipient.adl_records.order(recorded_at: :desc)
  end

  def new
    @adl_record = @care_recipient.adl_records.new
    authorize @adl_record
  end

  def create
    @adl_record = @care_recipient.adl_records.new(adl_record_params)
    @adl_record.recorded_by = current_user
    authorize @adl_record

    if @adl_record.save
      redirect_to care_recipient_adl_records_path(@care_recipient), notice: "ADL記録を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @adl_record
  end

  def update
    authorize @adl_record

    if @adl_record.update(adl_record_params)
      redirect_to care_recipient_adl_records_path(@care_recipient), notice: "ADL記録を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @adl_record
    @adl_record.destroy!
    redirect_to care_recipient_adl_records_path(@care_recipient), notice: "ADL記録を削除しました"
  end

  private

  def set_care_recipient
    @care_recipient = CareRecipient.find(params[:care_recipient_id])
  end

  def set_adl_record
    @adl_record = @care_recipient.adl_records.find(params[:id])
  end

  def adl_record_params
    params.require(:adl_record).permit(:recorded_at, :meal_intake, :excretion_status, :sleep_quality, :note)
  end
end
