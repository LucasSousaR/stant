class Integrations::ProcessSimpleObjectWorker
  include Sidekiq::Worker
  require 'securerandom'
  sidekiq_options queue: 'default'

  def perform(row, file, config = {}, columns = nil,  file_name, user_id, company_id, integration_id, date_balance)
    return if row.blank?
    #row = eval(row)
    # Prepare hash to save on DB
    hash = {}
    if columns
      columns.each_with_index do |i, idx|
        hash[i] = row[idx]
      end
    else
      hash = row
    end

    begin

      IntegrationDatum.create!(
        identification_document: integration_id,
        data_type: config['type'].to_s,
        integration_id: integration_id,
        version: config['version'],
        current_data: hash.to_h
      )

    rescue StandardError, UploadError => e
      print "Erro em salvar a integration datum #{e}"
    rescue  Exception => e
      print "Erro em salvar a integration datum #{e}"
    else
      #File.delete(file)
      #
    end


    end



  end
