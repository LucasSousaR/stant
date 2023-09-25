module CsvHelper
  include ActionView::Helpers::NumberHelper


  def formatted_field(payload)
    results = []
    I18n.locale = :'pt-BR'

    payload.each do |el|

      case el[0]
      when 'value', 'income', 'total_expenses', 'base_value'
        results << number_to_currency(el[1])
      when 'status'
        results << I18n.t("export.statuses.#{el[1]}", default: el[1])
      when 'disapproval_reason'
        results << I18n.t("export.disapproval_reasons.#{el[1]}", default: el[1])
      when 'cpf'
        size = el[1].size
        restant = 11 - size
        r = "#{('0' * restant)}#{el[1]}"
        results << CPF.new(r).formatted
      when 'updated_at', 'created_at', 'paid_at', 'released_at'
        begin
          results << DateTime.strptime(el[1],"%Y-%m-%d %H:%M:%S %Z").strftime('%d/%m/%Y %H:%M:%S')
        rescue ArgumentError, NoMethodError, TypeError, StandardError
          results << el[1]
        end
      when 'birthday'
        begin
          results <<  DateTime.strptime(el[1],"%Y-%m-%d").strftime('%d/%m/%Y')
        rescue ArgumentError, NoMethodError, TypeError, StandardError
          results << el[1]
        end
      else
        results << el[1]
      end
    end
    results
  end

  def testes(filepath, options, id_notification)
    teste(filepath, options, id_notification)
  end
end