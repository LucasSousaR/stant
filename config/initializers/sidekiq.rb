
Sidekiq.configure_server do |config|
  config.redis = { url: "#{ ENV['RACK_ENV'] == "production" ? ENV['REDIS_URL'] : 'redis://localhost:6379' }/11" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "#{ ENV['RACK_ENV'] == "production" ? ENV['REDIS_URL'] : 'redis://localhost:6379' }/11" }
end

