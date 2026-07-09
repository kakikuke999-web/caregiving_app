class MedicationRecordsController < ApplicationController
  before_action :set_care_recipient
  before_action :set_medication_record, only: %i[edit update destroy]

  def index
    authorize @care_recipient, :show?
    @medication_records = @care_recipient.medication_records.order(recorded_at: :desc)
  end

  def new
    @medication_record = @care_recipient.medication_records.new
    authorize @medication_record
  end

  def create
    @medication_record = @care_recipient.medication_records.new(medication_record_params)
    @medication_record.recorded_by = current_user
    authorize @medication_record

    if @medication_record.save
      redirect_to care_recipient_medication_records_path(@care_recipient), notice: "服薬記録を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @medication_record
  end

  def update
    authorize @medication_record

    if @medication_record.update(medication_record_params)
      redirect_to care_recipient_medication_records_path(@care_recipient), notice: "服薬記録を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @medication_record
    @medication_record.destroy!
    redirect_to care_recipient_medication_records_path(@care_recipient), notice: "服薬記録を削除しました"
  end

  private

  def set_care_recipient
    @care_recipient = CareRecipient.find(params[:care_recipient_id])
  end

  def set_medication_record
    @medication_record = @care_recipient.medication_records.find(params[:id])
  end

  def medication_record_params
    params.require(:medication_record).permit(:medication_name, :taken, :recorded_at, :note)
  end
end
