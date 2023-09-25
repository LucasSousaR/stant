class SettingUpTrackJob < ApplicationJob
  queue_as :default

  def perform(horario_inicial, minutos, horario_final)


  end

end
