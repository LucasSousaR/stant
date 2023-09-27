class Integrations::ProcessObjectWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'default'

  def perform(columns, row_json)
    return if row_json.blank?

    row = row_json.map { |i| i.try(:[], 'value') || '' }

    hash = {}
    columns.each_with_index do |i, idx|
      hash[i] = row[idx]
    end
    begin
      speech = {}
      hash.to_h.each do |h|
        if h[0].parameterize == "duracao"
          if  h[1].parameterize != "lightning"
            min = h[1].parameterize.gsub("min","")
            speech["#{h[0].parameterize}"] = min.to_i
          else
            speech["#{h[0].parameterize}"] = 5
          end
        else
          speech["#{h[0].parameterize}"] = h[1]
        end
      end

      speech_up = Speech.find_or_initialize_by(
        name: speech.to_h["palestra"],
        duration: speech.to_h["duracao"],
        check_session: false
      )
      speech_up.save!
    rescue StandardError, UploadError => e
      puts "Erro em salvar o upload #{e}"
    rescue  Exception => e
      puts "Erro em salvar  o upload #{e}"
    else

    end

  end
end