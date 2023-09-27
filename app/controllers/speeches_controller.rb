class SpeechesController < ApplicationController

  include ApplicationHelper
  #before_action :speech_params, only: %i[ show edit update destroy ]
  before_action :set_items, only: %i[ show edit update destroy ]


  # GET /speeches or /speeches.json
  def index

    search =''
    params_index = params.permit!
    params_to_search = params_index[:q] || {}

    to_search ={
      created_at_gteq:(Date.today - 30.days).beginning_of_day,
      created_at_lteq: Date.today.end_of_day
    }
    @rows = params_index['rows'].presence || 10
    @q = model_name.ransack(to_search)

    @items = @q.result(distinct: true).order(id: :desc)
    @items = @items.page(params[:page]).per(@rows)


    respond_to do |format|
      format.html  #index.html.erb
      format.json { render json: @items }
    end
  end

  # GET /speeches/1 or /speeches/1.json
  def show

  end

  # GET /speeches/new
  def new
    @item = Speech.new
  end

  # GET /speeches/1/edit
  def edit
    @item = model_name.where(id: params[:id].to_i)&.last

    respond_to do |format|
      format.html  #index.html.erb
      format.json { render json: @item }
    end
  end

  # POST /speeches or /speeches.json
  def create
    @item = model_name.new(items_params)
    @item.check_session = false

    respond_to do |format|
      if @item.save
        format.html { redirect_to speech_url(@item), notice: "Cadastro Realizado" }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /speeches/1 or /speeches/1.json
  def update
    respond_to do |format|
      if @item.update(items_params)
        format.html { redirect_to speech_url(@item), notice: "Upload Realizado" }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /speeches/1 or /speeches/1.json
  def destroy
    @item.destroy

    respond_to do |format|
      format.html { redirect_to "#{speech_url.to_s.gsub(speech_path, '')}/speeches", notice: "Deletado com sucesso" }
      format.json { head :no_content }
    end
  end

  # Only allow a list of trusted parameters through.

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_items
    @item = model_name.where(id: params[:id].to_i)&.last
    if @item.present?
      if params[:method] == "delete"
        destroy
      end
    end
    @item
  end
  def model_name
    Speech
  end
  # Only allow a list of trusted parameters through.
  def items_params
    params.require(:speech).permit(:id ,:name, :duration)
  end
end
