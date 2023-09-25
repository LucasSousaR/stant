class Track < ApplicationRecord


  has_many :track_session_speeches, dependent: :destroy
  has_many :sessions, through: :track_session_speeches
  has_many :speeches, through: :track_session_speeches

  def add_minutes_to_time(time, minutes_to_add)
    # Extrair horas e minutos do horário
    hours, minutes = time.divmod(60)

    # Adicionar os minutos
    minutes += minutes_to_add

    # Ajustar as horas se os minutos ultrapassarem 60
    hours += minutes / 60
    minutes %= 60

    # Retornar o horário formatado
    format('%02d:%02d', hours, minutes)
  end

  def minutes_in_interval(initial_time, array_minutes, end_time)
    # Converter os horários para minutos
    initial_time_minutes = initial_time * 60
    final_time_minutes = end_time * 60

    # Inicializar um array para armazenar as posições dos minutos no intervalo
    minutes_positions = []
    hours_positions = []

    # Inicializar uma variável para o somatório dos minutos
    somatorio_minutos = 0

    count = 0
    minutes =[]
    ids =[]

    array_minutes.each do |id, minute|
      minutes[count] = minute
      ids[count] = id
      count += 1
    end
    # Percorrer o array de minutos e calcular o somatório
    minutes.each_with_index do |minute, index|
      somatorio_minutos += minute
      if somatorio_minutos <=   final_time_minutes - initial_time_minutes
        minutes_positions << index
        if hours_positions[index - 1].nil?
          hours_positions[index]  = add_minutes_to_time( initial_time * 60 , minute)
        else
          hours_positions[index]  = add_minutes_to_time(  Time.parse(hours_positions[index - 1]).hour * 60 + Time.parse(hours_positions[index - 1]).min, minute)
        end

      end
    end
    id_positions = []
    ids.each_with_index do |id, index|
      puts "#{minutes[index]} - #{hours_positions[index]}"
      id_positions[index]  = {id: id, hour: hours_positions[index] }
    end
    # Retornar as posições dos minutos no intervalo
    id_positions

  end

  def calculate_remaining_hours(hours_str, minutes_to_remove)
    # Dividir a string em horas e minutos
    hours, minutes = hours_str.split(':').map(&:to_i)

    # Converter horas e minutos para minutos totais
    total_minutes = hours * 60 + minutes - minutes_to_remove

    # Calcular as horas e minutos restantes
    hours_left = total_minutes / 60
    minutes_left = total_minutes % 60

    [hours_left, minutes_left]
  end

  def sessions_speechs

    sessions = self.sessions.uniq

    sessions.each do |session|
      speechs = Speech.where(check_session: false).pluck(:id, :duration)
      if speechs.present?
        sp = self.minutes_in_interval(session.start, speechs, session.finish)

        sp.each do |s|

          track_session_speech = TrackSessionSpeech.where(track_id: self.id, session_id: session.id, speech_id: nil)&.last

          if track_session_speech.present?
            track_session_speech.speech_id = s[:id]
          else
            track_session_speech =  TrackSessionSpeech.find_or_initialize_by(
                track_id:self.id,
                session_id: session.id,
                speech_id: s[:id]
            )



          end


          speech = Speech.find(s[:id])
          speech.check_session = true
          speech.save!

          #track_session_speech.initial_hour =  session.start
          track_session_speech.finish_hour = s[:hour]
          track_session_speech.save!

        end
      end

    end
  end

  def track_session_speech

    track_session_speech_am = []
    track_session_speech_pm = []

    self.sessions.uniq.each do |session|
      count_pm = 0
      count_am = 0
      self.speeches.uniq.each_with_index do |speech, index|

        finish_hour = speech.track_session_speeches.where(speech_id: speech.id).where("finish_hour IS NOT NULL").first&.finish_hour

        hours_left, minutes_left =  self.calculate_remaining_hours(finish_hour, speech.duration )

        if minutes_left < 10
          minutes = "0" + minutes_left.to_s
        else
          minutes = minutes_left.to_s
        end

        if session.am_pm == "am"
          track_session_speech_am[index] = {name_speech: speech.name, duration: speech.duration.to_s, hour_start: "#{hours_left}:#{minutes}" }
          count_am += 1
        else
          track_session_speech_pm[index] = {name_speech: speech.name, duration: speech.duration.to_s, hour_start: "#{hours_left}:#{minutes}" }
          count_pm += 1
        end

      end

      if session.am_pm == "am"
        track_session_speech_am[count_am] = {name_speech: "Almoço", duration: "" , hour_start: "12:00" }
      else
        track_session_speech_pm[count_pm] = {name_speech: "Evento de Networking", duration: "" , hour_start: "17:00" }
      end

    end

    [track_session_speech_am, track_session_speech_pm]
  end
  scope :track_id_eq, -> (enum = '') {
    order("#{enum}": :asc)
  }
  def self.ransackable_scopes(auth_object = nil)
    %i(track_id_eq )
  end
end
