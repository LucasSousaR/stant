
class Integrations::ProcessDeleteAndInsertWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'default'
  def perform(file, file_name)



    Integrations::ProcessFileWorker.perform_async(file,  file_name  )
  end
end
