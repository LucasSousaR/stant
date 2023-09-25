class IntegrationsController < ApplicationController
  include ApplicationHelper

  before_action :set_items, only: %i[ show edit update destroy ]

  # GET /integrations or /integrations.json
  def index
    params_index = params.permit!

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


  # POST /integrations or /integrations.json
  def create
    parameters = params.require(:create_integration).permit(:file)
    begin
      uploader = IntegrationFilesUploader.new
      uploader.store!(parameters[:file])

    rescue StandardError, UploadError => e
      flash[:warning] = ['Ooops!', 'Algo deu errado!']
    else

      Integrations::ProcessFileWorker.perform_at(uploader.current_path, uploader.filename )

      respond_to do |format|
        format.html { redirect_to root_path, notice: "Importação iniciada" }

      end
      #flash[:success] = ['Tudo certo!', 'Importação iniciada']
      #redirect_back fallback_location: root_path
    end
  end


  private
  def model_name
    Integration
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_items
    @item = model_name.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def items_params
    params.require(:integration).permit(:name, :type_file)
  end
end
