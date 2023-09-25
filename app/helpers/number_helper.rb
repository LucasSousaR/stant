module NumberHelper
  def currency_to_number(c)
    c.to_s.gsub(/[^\d,]/,'').gsub(/,/,'.').to_f
  end
end