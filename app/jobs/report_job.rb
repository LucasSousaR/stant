class ReportJob < ApplicationJob
  queue_as :default

  def perform()
  end
end
