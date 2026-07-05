class CareRecipientsController < ApplicationController
  before_action :set_care_recipient, only: %i[ show edit update destroy calendar ]

  # GET /care_recipients or /care_recipients.json
  def index
    @care_recipients = policy_scope(CareRecipient)
  end

  # GET /care_recipients/1 or /care_recipients/1.json
  def show
    authorize @care_recipient
  end

  # GET /care_recipients/new
  def new
    @care_recipient = CareRecipient.new
    authorize @care_recipient
  end

  # GET /care_recipients/1/edit
  def edit
    authorize @care_recipient
  end

  # GET /care_recipients/1/calendar
  def calendar
    authorize @care_recipient, :show?
  end

  # POST /care_recipients or /care_recipients.json
  def create
    @care_recipient = CareRecipient.new(care_recipient_params)
    authorize @care_recipient

    respond_to do |format|
      if @care_recipient.save
        format.html { redirect_to @care_recipient, notice: "Care recipient was successfully created." }
        format.json { render :show, status: :created, location: @care_recipient }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @care_recipient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /care_recipients/1 or /care_recipients/1.json
  def update
      authorize @care_recipient
      # 写真削除チェック（チェックボックスがオンなら削除）
  if params[:care_recipient][:remove_photo] == "1"
    @care_recipient.photo.purge
  end

  respond_to do |format|
      if @care_recipient.update(care_recipient_params)
        format.html { redirect_to @care_recipient, notice: "Care recipient was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @care_recipient }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @care_recipient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /care_recipients/1 or /care_recipients/1.json
  def destroy
    authorize @care_recipient
    @care_recipient.destroy!

    respond_to do |format|
      format.html { redirect_to care_recipients_path, notice: "Care recipient was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_care_recipient
      @care_recipient = CareRecipient.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def care_recipient_params
      params.require(:care_recipient).permit(:name, :birthday, :address, :care_level, :memo, :photo)
    end
end
