class Integrations::ProcessObjectWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'default'

  def perform(columns, row_json, type, version, id_column, num_coop,config, risk)
    return if row_json.blank?

    row = row_json.map { |i| i.try(:[], 'value') || '' }


        identification_document = if !risk.nil?
                                    row[num_coop].to_s + row[risk].to_s + row[id_column].to_s
                                 elsif !num_coop.nil?
                                   row[num_coop].to_s + row[id_column].to_s
                                  else
                                    row[id_column]
                                  end

        identification_document = identification_document.to_s.gsub(/[^\d]/, '')
      # end


      return if identification_document.blank?


      data_type = if config['row_prefix'].present?
                    "#{type}_#{row[config['row_prefix'].to_s.parameterize(separator: '_')]}"
                  elsif config['var_prefix'].present?
                    "#{type}_#{row[config['var_prefix'].to_s.parameterize(separator: '_')]}"
                  else
                    type
                  end

      object = IntegrationDatum.find_or_initialize_by(
        identification_document: identification_document.gsub(/[^\d]/, ''),
        data_type: data_type
      )
      object.data_type = type
      object.version = version
      hash = {}
      columns.each_with_index do |i, idx|
        hash[i] = row[idx]
      end
      object.current_data = hash
      object.save!

  end
end