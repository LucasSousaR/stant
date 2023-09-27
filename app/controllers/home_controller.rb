class HomeController < ApplicationController

  include ApplicationHelper
  def index

    params_to_search = params[:q] || {}
    @q =  Track.ransack({})
    @track = nil

    if params_to_search.present?
      @track = Track.find(params_to_search['id_eq'])

      @track.sessions_speechs
      @track_session_speech_am, @track_session_speech_pm =   @track.track_session_speech

      @track_session_speech_am.sort_by!{  |obj| obj[:hour_start].split(':').map(&:to_i) }
      @track_session_speech_pm.sort_by!{  |obj| obj[:hour_start].split(':').map(&:to_i) }
    end



    @item = @q.result(distinct: true).last


  #horas_restantes, minutos_restantes = calcular_horas_restantes(horas_str, minutos_a_remover)



  end

end
