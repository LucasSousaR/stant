require 'csv'
require 'scanf'
require 'smarter_csv'
require 'charlock_holmes'

class Integrations::ProcessFileWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'default'
  def perform(file,  file_name )

      extension = Roo::Spreadsheet.extension_for(file, {})

      objectIntegration = Integration.find_or_initialize_by(
        name: file_name ,
        type_file: extension.to_s
      )

      objectIntegration.save

      case extension.to_s
      when 'csv'
        csv_process(file, file_name, objectIntegration.id )
        else
        general_process(file, file_name, objectIntegration.id)
      end

    
  end

  def csv_process(file,  file_name, integration_id)
    file_encoding = CharlockHolmes::EncodingDetector.new.detect(File.read(file))
    count = 0
    row_skip = 0

    csv = SmarterCSV.process(file, { col_sep: ';', skip_lines: row_skip, file_encoding: file_encoding })
    if csv[0].count < 2 #Não possui importações com apenas UMA coluna
      csv = SmarterCSV.process(file, { col_sep: ',', skip_lines: row_skip, file_encoding: file_encoding })
    end
    count_csv_row = csv.count
    return if csv.nil?


     version = (IntegrationDatum.where(data_type: 0).first&.try(:version) || 0) + 1


    csv.each do |row|
      count = count + 1
      if count_csv_row - 1  == count
        File.delete(file) if File.exist?(file)
      end
      begin
        Integrations::ProcessSimpleObjectWorker.perform_async(row.to_h, file, config, file_name, integration_id )
      rescue Exception => e
      e
      end
      #unless
      # Integrations::ProcessSimpleObjectWorker.perform_async(row.as_json, file, config, file_name, user_id, company_id, integration_id )
      #rescue_from ActiveJob::DeserializationError do |exception|
          # exception
        #end
        #end
    end
  end

  def general_process(file,  file_name, integration_id)
    spreadsheet = Roo::Spreadsheet.open(file)
    count_spreadsheet = spreadsheet.count
    return if spreadsheet.nil?

    row_skip = 0
    columns = ''

    version = (IntegrationDatum.where(data_type: 1).first&.try(:version) || 0) + 1
    count = 0

    spreadsheet.each_row_streaming(offset: row_skip, pad_cells: true) do |row|
      if columns.present?
        count = count + 1
        if count_spreadsheet - 1  == count
          File.delete(file) if File.exist?(file)
        end
        Integrations::ProcessObjectWorker.perform_async(columns, row.as_json, 1, version,  config, config['risk'])
      else
        columns = row.map { |i| i.value.parameterize(separator: '_') }
      end
    end
  end

end
